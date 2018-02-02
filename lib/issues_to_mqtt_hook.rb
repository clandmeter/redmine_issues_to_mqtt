class MqttHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context = {})
    issue = context[:issue]
    user = issue.author
    values = { 
      author: user.name,
      subject: issue.subject.strip,
      issue_id: issue.id,
      project: issue.project.name,
      tracker: issue.tracker.name,
      status: 'new'
    }

    payload = JSON.generate(values)
    send_mqtt_message(payload)
  end

  private
  def send_mqtt_message(payload)
    require 'rubygems'
    require 'mqtt'

    host = Setting.plugin_redmine_issues_to_mqtt['mqtt_host']
    topic = Setting.plugin_redmine_issues_to_mqtt['mqtt_topic']
    begin
      MQTT::Client.connect(host) do |c|
        c.publish(topic, payload)
      end
    rescue StandardError => e
      Rails.logger.error "\033[31mFailed to publish MQTT message:\033[0m"
      Rails.logger.error "  #{e.message}"
    end
  end

end

