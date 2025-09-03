class SetEnterprisePlan < ActiveRecord::Migration[7.0]
  def up
    # Update all accounts to enterprise plan
    execute <<-SQL
      UPDATE accounts 
      SET custom_attributes = jsonb_set(
        COALESCE(custom_attributes, '{}'::jsonb),
        '{pricing_plan}',
        '"enterprise"'::jsonb
      )
    SQL
    
    # Update installation config
    execute <<-SQL
      INSERT INTO installation_configs (name, value, locked, created_at, updated_at)
      VALUES 
        ('INSTALLATION_PRICING_PLAN', 'enterprise', true, NOW(), NOW()),
        ('CW_EDITION', 'ee', true, NOW(), NOW()),
        ('INSTALLATION_PRICING_PLAN_QUANTITY', '999999', true, NOW(), NOW())
      ON CONFLICT (name) 
      DO UPDATE SET value = EXCLUDED.value, updated_at = NOW()
    SQL
    
    puts "✅ All accounts upgraded to Enterprise Edition!"
  end
  
  def down
    # Revert to community if needed
    execute <<-SQL
      UPDATE accounts 
      SET custom_attributes = jsonb_set(
        COALESCE(custom_attributes, '{}'::jsonb),
        '{pricing_plan}',
        '"community"'::jsonb
      )
    SQL
  end
end