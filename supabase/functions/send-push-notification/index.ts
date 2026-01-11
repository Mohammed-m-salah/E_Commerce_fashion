// Supabase Edge Function لإرسال Push Notifications عبر FCM
// يجب رفع هذا الملف إلى Supabase Edge Functions

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY")!; // يجب إضافته في Supabase Secrets

interface NotificationPayload {
  record: {
    chat_room_id: string;
    message: string;
    is_admin: boolean;
  };
}

serve(async (req) => {
  try {
    const payload: NotificationPayload = await req.json();
    const { chat_room_id, message, is_admin } = payload.record;

    // فقط نرسل إشعار إذا كان المرسل هو الأدمين
    if (!is_admin) {
      return new Response(JSON.stringify({ success: true, message: "Not admin message" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    // إنشاء Supabase client
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // 1. الحصول على user_id من chat_room
    const { data: chatRoom, error: chatRoomError } = await supabase
      .from("chat_rooms")
      .select("user_id")
      .eq("id", chat_room_id)
      .single();

    if (chatRoomError || !chatRoom) {
      console.error("Error fetching chat room:", chatRoomError);
      return new Response(JSON.stringify({ error: "Chat room not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }

    const userId = chatRoom.user_id;

    // 2. الحصول على FCM token للمستخدم
    const { data: tokenData, error: tokenError } = await supabase
      .from("user_tokens")
      .select("fcm_token")
      .eq("user_id", userId)
      .order("updated_at", { ascending: false })
      .limit(1)
      .single();

    if (tokenError || !tokenData?.fcm_token) {
      console.error("Error fetching FCM token:", tokenError);
      return new Response(JSON.stringify({ error: "FCM token not found" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }

    const fcmToken = tokenData.fcm_token;

    // 3. إرسال FCM notification
    const fcmResponse = await fetch("https://fcm.googleapis.com/fcm/send", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `key=${FCM_SERVER_KEY}`,
      },
      body: JSON.stringify({
        to: fcmToken,
        notification: {
          title: "رسالة جديدة من الدعم",
          body: message.length > 100 ? message.substring(0, 100) + "..." : message,
          sound: "default",
          badge: "1",
        },
        data: {
          type: "chat",
          chat_room_id: chat_room_id,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        android: {
          priority: "high",
          notification: {
            channel_id: "chat_channel",
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
      }),
    });

    const fcmResult = await fcmResponse.json();
    console.log("FCM Response:", fcmResult);

    // 4. حفظ الإشعار في جدول notifications (اختياري)
    await supabase.from("notifications").insert({
      user_id: userId,
      title: "رسالة جديدة من الدعم",
      body: message,
      type: "chat",
      is_read: false,
      data: { chat_room_id },
    });

    return new Response(
      JSON.stringify({ success: true, fcm_result: fcmResult }),
      {
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Error:", error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
