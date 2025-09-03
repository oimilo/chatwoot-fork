-- Forçar configuração Enterprise (com JSON correto)
INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at) 
VALUES ('INSTALLATION_PRICING_PLAN', '{"value": "enterprise"}'::jsonb, true, NOW(), NOW())
ON CONFLICT (name) 
DO UPDATE SET serialized_value = '{"value": "enterprise"}'::jsonb, locked = true, updated_at = NOW();

INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at) 
VALUES ('CW_EDITION', '{"value": "ee"}'::jsonb, true, NOW(), NOW())
ON CONFLICT (name) 
DO UPDATE SET serialized_value = '{"value": "ee"}'::jsonb, locked = true, updated_at = NOW();

INSERT INTO installation_configs (name, serialized_value, locked, created_at, updated_at)
VALUES ('INSTALLATION_PRICING_PLAN_QUANTITY', '{"value": 999999}'::jsonb, true, NOW(), NOW())
ON CONFLICT (name)
DO UPDATE SET serialized_value = '{"value": 999999}'::jsonb, locked = true, updated_at = NOW();

-- Atualizar todas as contas para Enterprise
UPDATE accounts 
SET custom_attributes = jsonb_build_object(
  'pricing_plan', 'enterprise',
  'plan_name', 'Enterprise', 
  'subscribed_quantity', 999999
);

-- Marcar usuário como admin no custom_attributes (já que não existe coluna super_admin)
UPDATE users 
SET custom_attributes = jsonb_set(
  COALESCE(custom_attributes, '{}'::jsonb),
  '{is_admin}',
  'true'::jsonb,
  true
)
WHERE email = 'bonitoemail@gmail.com';

-- Verificar resultados
SELECT name, serialized_value FROM installation_configs WHERE name LIKE '%PRICING%' OR name LIKE '%EDITION%';
SELECT email, custom_attributes FROM users WHERE email = 'bonitoemail@gmail.com';
SELECT id, name, custom_attributes FROM accounts;