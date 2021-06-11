# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'

set :database_file, 'config/database.yml'

class Alert < ActiveRecord::Base
  validates_presence_of :message
end

module AlertService
  module_function

  def create!(message:)
    Alert.create!(message: message)
  end
end

class AlertWeb < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  CRASH_CMD = 'CRASH'
  CRASH_DURATION = 2

  get '/' do
  end

  get '/alerts' do
    json alerts: Alert.order(id: :desc).first(5)
  end

  post '/alerts' do
    AlertService.create!(message: params[:message])
  rescue ActiveRecord::RecordInvalid => e
    json errors: e.record.errors.full_messages
  end

  get '/health_check' do
    latest_alert = Alert.last
    if latest_alert && latest_alert.message == CRASH_CMD && Time.current.advance(minutes: -CRASH_DURATION) < latest_alert.created_at
      json ok: false
    else
      json ok: true
    end
  end
end
