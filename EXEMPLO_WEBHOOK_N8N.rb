#!/usr/bin/env ruby
# Exemplo de configuração de webhook e bot para n8n

# 1. Criar Webhook para n8n
def criar_webhook_n8n(account, n8n_url)
  webhook = account.webhooks.create!(
    url: "#{n8n_url}/webhook/chatwoot-events",
    subscriptions: {
      'conversation_created' => true,
      'conversation_status_changed' => true,
      'conversation_updated' => true,
      'message_created' => true,
      'message_updated' => true,
      'contact_created' => true,
      'contact_updated' => true
    }
  )
  puts "✅ Webhook criado: #{webhook.url}"
  webhook
end

# 2. Criar Agent Bot para n8n
def criar_bot_n8n(account, n8n_url)
  bot = account.agent_bots.create!(
    name: 'n8n Automation Bot',
    description: 'Bot que conecta com fluxos n8n',
    outgoing_url: "#{n8n_url}/webhook/chatwoot-bot",
    bot_type: 0, # webhook type
    bot_config: {
      process_all_messages: true,
      handoff_on_error: true
    }
  )
  puts "✅ Bot criado: #{bot.name}"
  bot
end

# 3. Configurar WhatsApp Cloud API
def configurar_whatsapp_cloud(account, config)
  inbox = account.inboxes.create!(
    name: 'WhatsApp Business',
    channel: Channel::Whatsapp.create!(
      account: account,
      phone_number: config[:phone_number],
      provider: 'whatsapp_cloud',
      provider_config: {
        api_key: config[:access_token],
        phone_number_id: config[:phone_number_id],
        business_account_id: config[:business_id],
        webhook_verify_token: SecureRandom.hex(20)
      }
    )
  )
  puts "✅ WhatsApp configurado: #{inbox.name}"
  inbox
end

# 4. Associar Bot ao Inbox
def associar_bot_ao_inbox(inbox, bot)
  inbox.agent_bot_inbox = AgentBotInbox.create!(
    inbox: inbox,
    agent_bot: bot
  )
  inbox.save!
  puts "✅ Bot associado ao inbox"
end

# 5. Criar token de API para n8n usar
def criar_token_api(account)
  # Criar usuário dedicado para o bot
  user = User.create!(
    email: 'n8n-bot@chatwoot.local',
    password: SecureRandom.hex(20),
    name: 'n8n Bot User',
    confirmed_at: Time.now
  )
  
  # Associar à conta como agente
  AccountUser.create!(
    account: account,
    user: user,
    role: :agent
  )
  
  # Obter token
  token = user.access_token.token
  puts "✅ Token API criado: #{token}"
  token
end

# EXEMPLO DE USO:
# ---------------
# account = Account.first
# n8n_url = "https://n8n.exemplo.com"
# 
# webhook = criar_webhook_n8n(account, n8n_url)
# bot = criar_bot_n8n(account, n8n_url)
# 
# whatsapp_config = {
#   phone_number: '+5511999999999',
#   access_token: 'EAAxxxxx',
#   phone_number_id: '123456789',
#   business_id: '987654321'
# }
# 
# inbox = configurar_whatsapp_cloud(account, whatsapp_config)
# associar_bot_ao_inbox(inbox, bot)
# token = criar_token_api(account)
# 
# puts "\n📋 CONFIGURAÇÃO COMPLETA:"
# puts "========================"
# puts "Webhook URL: #{webhook.url}"
# puts "Bot URL: #{bot.outgoing_url}"
# puts "API Token: #{token}"
# puts "WhatsApp: #{inbox.channel.phone_number}"