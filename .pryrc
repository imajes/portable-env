# frozen_string_literal: true

Pry.hooks.add_hook :before_session, :rails do |_output, _target, _pry|
  if defined?(Rails) && Rails.env
    # load Rails console commands
    require 'rails/console/app'
    require 'rails/console/helpers'
    # require 'zipline/console_helpers'
    # Rails::ConsoleMethods.include Zipline::ConsoleHelpers
    # Rails::ConsoleMethods.extend Zipline::ConsoleMethods
    #
    # extend Rails::ConsoleMethods if Rails.const_defined? :ConsoleMethods
  end
end

Pry.config.completer = nil ### too slow

if ENV["PRY_HISTFILE"]
  Pry.config.history_save = true
  Pry.config.history_file = ENV["PRY_HISTFILE"]
  puts " - Loaded Pry history"
end

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'b', 'break'
  Pry.commands.alias_command 'q', 'quit'
  puts " - Loaded Byebug aliases"
end

# db_configured =
#   begin
#     Apartment::Tenant.current
#     true
#   rescue ActiveRecord::ConnectionNotEstablished
#     false
#   end

if Pry::Prompt[:rails]
  formatted_env = if Rails.env.production?
                    Pry::Helpers::Text.red(Pry::Helpers::Text.bold('prod'))
                  elsif Rails.env.development?
                    Pry::Helpers::Text.green('dev')
                  else
                    Pry::Helpers::Text.white(Rails.env)
                  end

  desc = <<~TXT
    Includes the current organization and Rails environment.
      "[1] [current_org][Rails.env] »"
  TXT

  # org =
  #   if db_configured
  #     Apartment::Tenant.current == 'public' ? '' : Pry::Helpers::Text.purple(Apartment::Tenant.current)
  #   else
  #     '-'
  #   end

  Pry::Prompt.add 'custom', desc, %w[» *] do |context, _nesting, pry_instance, sep|
    format(
      "%<in_count>s: [%<org>s][%<env>s] %<context>s%<separator>s ",
      in_count: Pry::Helpers::Text.blue(pry_instance.input_ring.count),
      org: "*",#org,
      env: formatted_env,
      context: Pry.view_clip(context) == 'main' ? '' : Pry.view_clip(context),
      separator: Pry::Helpers::Text.magenta(sep)
    )
  end

  Pry.config.prompt = Pry::Prompt[:custom]
  puts " - Added custom prompt"
end

if File.exist?(File.expand_path('~/.pryrc.local'))
  load File.expand_path('~/.pryrc.local')
  puts " - Loaded local Pry tweaks from ~/.pryrc.local"
end

