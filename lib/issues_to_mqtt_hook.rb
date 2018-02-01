class MqttHook < Redmine::Hook::ViewListener

  def controller_issues_new_after_save(context = {})
    issue = context[:issue]
    user = issue.author
    values = { 
      author: user.name,
      subject: issue.subject,
      issue_id: issue.id.to_s,
      project: issue.project.name,
      tracker: issue.tracker.name,
      status: 'new'
    }

    payload = JSON.generate(values)
    send_mqtt_message(payload)
  end

  private
  def send_mqtt_message(payload)
    host = Setting.plugin_issues_to_mqtt['mqtt_host']
    topic = Setting.plugin_issues_to_mqtt['mqtt_topic']
    begin
      MQTT::Client.connect(host) do |c|
        c.publish(topic, payload)
      end
    rescue StandardError => e
      print e
    end
  end

end