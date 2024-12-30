# frozen_string_literal: true

require 'digest'
require 'json'
require 'net/http'
require 'uri'
require 'base64'

class Jira
  ATLASSIAN_BASE_URL = 'https://%s.atlassian.net'
  attr_reader :project_prefix

  def initialize
    load_credentials
  end

  def get_project_issues(project_key)
    jql = "project=#{project_key} ORDER BY updated DESC"
    uri = URI("#{@api_url}/rest/api/3/search")
    uri.query = URI.encode_www_form(jql: jql)

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Basic #{auth_header}"
    request['Accept'] = 'application/json'

    response = send_request(uri, request)
    body = JSON.parse(response.body)
    body['issues']
  end

  private

  def auth_header
    Base64.strict_encode64("#{@email}:#{@api_key}")
  end

  def send_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.set_debug_output($stdout) if ENV['DEBUG']

    http.request(request)
  end

  def save_credentials
    File.write('.jira_credentials', "#{@api_key}\n#{@email}\n#{@api_url}\n#{@project_prefix}")
  end

  def load_credentials
    return load_stored_credentials if File.exist?('.jira_credentials')

    prompt_for_credentials
  end

  def load_stored_credentials
    api_key, email, api_url, project_prefix = File.read('.jira_credentials').split("\n")
    @api_key = api_key
    @email = email
    @api_url = api_url
    @project_prefix = project_prefix
  end

  def prompt_for_credentials
    puts "\nTo use this tool, you'll need:"
    puts '1. A Jira API token (create one at https://id.atlassian.com/manage-profile/security/api-tokens)'
    puts '2. Your Atlassian account email'
    puts "3. Your Jira instance name (e.g., if your Jira URL is https://company.atlassian.net, enter 'company')"
    puts '4. Your project prefix (e.g., PEG)'
    puts "\n"

    puts 'Please enter your Jira API key:'
    @api_key = gets.chomp
    raise 'API key is required' if @api_key.empty?

    puts 'Please enter your Jira email:'
    @email = gets.chomp
    raise 'Email is required' if @email.empty?

    puts 'Please enter your Jira instance name (e.g., mycompany):'
    instance_name = gets.chomp.downcase
    raise 'Instance name is required' if instance_name.empty?

    @api_url = format(ATLASSIAN_BASE_URL, instance_name)

    puts 'Please enter your project prefix (e.g., PEG):'
    @project_prefix = gets.chomp.upcase
    raise 'Project prefix is required' if @project_prefix.empty?

    save_credentials
  end
end
