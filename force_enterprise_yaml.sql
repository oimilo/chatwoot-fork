-- Forçar configuração Enterprise usando formato YAML correto
-- O Rails espera um YAML serializado dentro do JSONB

-- INSTALLATION_PRICING_PLAN = 'enterprise'
INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at) 
VALUES (
  'INSTALLATION_PRICING_PLAN', 
  '{"value": "enterprise"}'::jsonb,
  true, 
  NOW(), 
  NOW()
)
ON CONFLICT (name) 
DO UPDATE SET 
  serialized_value = '{"value": "enterprise"}'::jsonb, 
  locked = true, 
  updated_at = NOW();

-- CW_EDITION = 'ee'  
INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at) 
VALUES (
  'CW_EDITION', 
  '{"value": "ee"}'::jsonb,
  true, 
  NOW(), 
  NOW()
)
ON CONFLICT (name) 
DO UPDATE SET 
  serialized_value = '{"value": "ee"}'::jsonb, 
  locked = true, 
  updated_at = NOW();

-- INSTALLATION_PRICING_PLAN_QUANTITY = 999999
INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at) 
VALUES (
  'INSTALLATION_PRICING_PLAN_QUANTITY', 
  '{"value": 999999}'::jsonb,
  true, 
  NOW(), 
  NOW()
)
ON CONFLICT (name) 
DO UPDATE SET 
  serialized_value = '{"value": 999999}'::jsonb, 
  locked = true, 
  updated_at = NOW();

-- Verificar resultados
SELECT name, serialized_value FROM installation_configs 
WHERE name IN ('INSTALLATION_PRICING_PLAN', 'CW_EDITION', 'INSTALLATION_PRICING_PLAN_QUANTITY');