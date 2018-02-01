require 'redmine'
require 'rubygems'
require 'mqtt'
require_dependency 'issues_to_mqtt_hook'

Redmine::Plugin.register :redmine_issues_to_mqtt do
  name 'Issues to MQTT'
  author 'Carlo Landmeter'
  description 'A plugin to send issues metadata to MQTT'
  version '0.0.1'
  settings :partial => 'settings/issues_to_mqtt', :default => { 
    'mqtt_host' => 'test.mosquitto.org',
    'mqtt_topic' => 'issues'
  }
end
