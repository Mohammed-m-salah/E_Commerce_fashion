-- Add clothing products to the products table
-- Run this SQL in Supabase SQL Editor

-- Men's Clothing
INSERT INTO public.products (name, description, price, image_url, category, stock, rating)
VALUES
  ('Men''s Classic T-Shirt', 'Premium cotton t-shirt with comfortable fit', 29.99, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', 'Men', 50, 4.5),
  ('Men''s Denim Jeans', 'Stylish slim-fit denim jeans', 79.99, 'https://images.unsplash.com/photo-1542272454315-7fbeb6d3e883?w=500', 'Men', 35, 4.7),
  ('Men''s Leather Jacket', 'Genuine leather jacket for winter', 199.99, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500', 'Men', 15, 4.8),
  ('Men''s Casual Shirt', 'Long sleeve casual shirt', 49.99, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500', 'Men', 40, 4.4),
  ('Men''s Hoodie', 'Comfortable cotton hoodie', 59.99, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500', 'Men', 45, 4.6),
  ('Men''s Chino Pants', 'Slim fit chino pants', 69.99, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500', 'Men', 30, 4.3),
  ('Men''s Sports Shoes', 'Running shoes with excellent grip', 89.99, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500', 'Men', 25, 4.7),
  ('Men''s Formal Suit', 'Two-piece formal suit', 299.99, 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500', 'Men', 12, 4.9);

-- Women's Clothing
INSERT INTO public.products (name, description, price, image_url, category, stock, rating)
VALUES
  ('Women''s Summer Dress', 'Elegant floral summer dress', 69.99, 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500', 'Women', 40, 4.6),
  ('Women''s Denim Jacket', 'Classic denim jacket', 89.99, 'https://images.unsplash.com/photo-1578932750294-f5075e85f44a?w=500', 'Women', 30, 4.5),
  ('Women''s Yoga Pants', 'Stretchy comfortable yoga pants', 49.99, 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=500', 'Women', 55, 4.7),
  ('Women''s Blouse', 'Silk blouse for office wear', 59.99, 'https://images.unsplash.com/photo-1564257577817-1e5c92d1c5bd?w=500', 'Women', 35, 4.4),
  ('Women''s Evening Gown', 'Elegant evening dress', 199.99, 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500', 'Women', 8, 4.9),
  ('Women''s Jeans', 'High-waist skinny jeans', 79.99, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500', 'Women', 42, 4.6),
  ('Women''s Cardigan', 'Cozy knit cardigan', 54.99, 'https://images.unsplash.com/photo-1583744946564-b52ac1c389c8?w=500', 'Women', 38, 4.5),
  ('Women''s Sneakers', 'Casual white sneakers', 79.99, 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500', 'Women', 28, 4.7),
  ('Women''s Handbag', 'Designer leather handbag', 149.99, 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500', 'Women', 20, 4.8);

-- Kids' Clothing
INSERT INTO public.products (name, description, price, image_url, category, stock, rating)
VALUES
  ('Kids'' T-Shirt Set', 'Colorful t-shirt pack of 3', 34.99, 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=500', 'Kids', 60, 4.6),
  ('Kids'' Denim Shorts', 'Comfortable denim shorts', 29.99, 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=500', 'Kids', 50, 4.4),
  ('Kids'' Winter Jacket', 'Warm winter jacket for kids', 79.99, 'https://images.unsplash.com/photo-1514090458221-65bb69cf63e7?w=500', 'Kids', 25, 4.7),
  ('Kids'' Sneakers', 'Colorful running shoes for kids', 49.99, 'https://images.unsplash.com/photo-1514989940723-e8e51635b782?w=500', 'Kids', 45, 4.5),
  ('Kids'' Hoodie', 'Soft cotton hoodie', 39.99, 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?w=500', 'Kids', 55, 4.6),
  ('Kids'' Dress', 'Pretty party dress for girls', 59.99, 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=500', 'Kids', 30, 4.8),
  ('Kids'' Backpack', 'Colorful school backpack', 34.99, 'https://images.unsplash.com/photo-1577655197620-704858b270ac?w=500', 'Kids', 40, 4.5),
  ('Kids'' Pajama Set', 'Comfortable cotton pajamas', 29.99, 'https://images.unsplash.com/photo-1596870230751-ebdfce98ec42?w=500', 'Kids', 65, 4.7);

-- Update stock for low inventory items to trigger "Only X left" badge
UPDATE public.products SET stock = 5 WHERE name = 'Women''s Evening Gown';
UPDATE public.products SET stock = 8 WHERE name = 'Men''s Leather Jacket';
UPDATE public.products SET stock = 7 WHERE name = 'Men''s Formal Suit';
