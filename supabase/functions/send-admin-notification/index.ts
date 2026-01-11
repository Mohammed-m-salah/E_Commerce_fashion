// Supabase Edge Function لإرسال Push Notifications من الأدمن
// يستخدم FCM v1 API مع Service Account

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { create, getNumericDate } from "https://deno.land/x/djwt@v2.8/mod.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// Service Account credentials (من ملف JSON)
const FCM_PROJECT_ID = Deno.env.get("FCM_PROJECT_ID")!;
const FCM_CLIENT_EMAIL = Deno.env.get("FCM_CLIENT_EMAIL")!;
const FCM_PRIVATE_KEY = Deno.env.get("FCM_PRIVATE_KEY")!;

interface NotificationRequest {
  user_id?: string;
  user_ids?: string[];
  send_to_all?: boolean;
  title: string;
  body: string;
  type: string;
  data?: Record<string, string>;
}

// ========== الحصول على Access Token من Google ==========
async function getAccessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000);

  // تحويل Private Key من format مع \n
  const privateKeyPEM = FCM_PRIVATE_KEY.replace(/\\n/g, "\n");

  // استيراد المفتاح الخاص
  const pemHeader = "-----BEGIN PRIVATE KEY-----";
  const pemFooter = "-----END PRIVATE KEY-----";
  const pemContents = privateKeyPEM
    .replace(pemHeader, "")
    .replace(pemFooter, "")
    .replace(/\s/g, "");

  const binaryKey = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryKey,
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"]
  );

  // إنشاء JWT
  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: FCM_CLIENT_EMAIL,
      sub: FCM_CLIENT_EMAIL,
      aud: "https://oauth2.googleapis.com/token",
      iat: getNumericDate(0),
      exp: getNumericDate(60 * 60), // صالح لمدة ساعة
      scope: "https://www.googleapis.com/auth/firebase.messaging",
    },
    cryptoKey
  );

  // طلب Access Token من Google
  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  const tokenData = await tokenResponse.json();

  if (!tokenData.access_token) {
    console.error("Token response:", tokenData);
    throw new Error("Failed to get access token");
  }

  return tokenData.access_token;
}

// ========== إرسال إشعار واحد عبر FCM v1 ==========
async function sendFCMv1(
  accessToken: string,
  fcmToken: string,
  title: string,
  body: string,
  type: string,
  data?: Record<string, string>
): Promise<{ success: boolean; error?: string }> {
  try {
    const message = {
      message: {
        token: fcmToken,
        notification: {
          title: title,
          body: body.length > 200 ? body.substring(0, 200) + "..." : body,
        },
        data: {
          type: type,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
          ...data,
        },
        android: {
          priority: "high" as const,
          notification: {
            channel_id: "admin_notifications",
            sound: "default",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      },
    };

    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${FCM_PROJECT_ID}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify(message),
      }
    );

    if (response.ok) {
      return { success: true };
    } else {
      const error = await response.json();
      console.error("FCM Error:", error);
      return { success: false, error: JSON.stringify(error) };
    }
  } catch (error) {
    console.error("Send error:", error);
    return { success: false, error: error.message };
  }
}

// ========== Main Handler ==========
serve(async (req) => {
  // Handle CORS
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
    });
  }

  try {
    const payload: NotificationRequest = await req.json();
    const { user_id, user_ids, send_to_all, title, body, type, data } = payload;

    // التحقق من البيانات
    if (!title || !body) {
      return new Response(
        JSON.stringify({ error: "Title and body are required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    let targetUserIds: string[] = [];

    // تحديد المستخدمين المستهدفين
    if (send_to_all) {
      const { data: users, error } = await supabase
        .from("profiles")
        .select("id");
      if (error) throw error;
      targetUserIds = users?.map((u) => u.id) || [];
    } else if (user_ids && user_ids.length > 0) {
      targetUserIds = user_ids;
    } else if (user_id) {
      targetUserIds = [user_id];
    } else {
      return new Response(
        JSON.stringify({ error: "No target users specified" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    console.log(`📤 Sending notification to ${targetUserIds.length} users`);

    // جلب FCM tokens
    const { data: tokens, error: tokenError } = await supabase
      .from("user_tokens")
      .select("user_id, fcm_token")
      .in("user_id", targetUserIds);

    if (tokenError) {
      console.error("Error fetching tokens:", tokenError);
      throw tokenError;
    }

    if (!tokens || tokens.length === 0) {
      // حفظ الإشعارات في DB حتى لو لم يكن هناك tokens
      const notifications = targetUserIds.map((userId) => ({
        user_id: userId,
        title: title,
        body: body,
        type: type,
        is_read: false,
        data: data || null,
        created_at: new Date().toISOString(),
      }));
      await supabase.from("notifications").insert(notifications);

      return new Response(
        JSON.stringify({
          success: true,
          message: "Notifications saved but no FCM tokens found",
          sent_count: 0,
          saved_count: targetUserIds.length
        }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // الحصول على Access Token
    console.log("🔑 Getting access token...");
    const accessToken = await getAccessToken();
    console.log("✅ Access token obtained");

    // إرسال Push Notifications
    const fcmResults = await Promise.all(
      tokens.map(async (tokenData) => {
        const result = await sendFCMv1(
          accessToken,
          tokenData.fcm_token,
          title,
          body,
          type,
          data
        );
        return { user_id: tokenData.user_id, ...result };
      })
    );

    const successCount = fcmResults.filter((r) => r.success).length;
    console.log(`✅ Sent ${successCount}/${tokens.length} push notifications`);

    // حفظ الإشعارات في قاعدة البيانات
    const notifications = targetUserIds.map((userId) => ({
      user_id: userId,
      title: title,
      body: body,
      type: type,
      is_read: false,
      data: data || null,
      created_at: new Date().toISOString(),
    }));

    const { error: insertError } = await supabase
      .from("notifications")
      .insert(notifications);

    if (insertError) {
      console.error("Error saving notifications:", insertError);
    } else {
      console.log(`✅ Saved ${notifications.length} notifications to database`);
    }

    return new Response(
      JSON.stringify({
        success: true,
        push_sent_count: successCount,
        push_total: tokens.length,
        saved_count: targetUserIds.length,
        fcm_results: fcmResults,
      }),
      {
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 500,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  }
});
