class JiraCheckout < Formula
  desc 'Checkout to branch from Jira'
  homepage 'https://github.com/krzysztoff1/jira-checkout-rb'
  version '1.0.0'

  url 'https://github.com/krzysztoff1/jira-checkout-rb/archive/main.zip', :using => :curl

  def install
    bin.install 'bin/jira_checkout'
  end
end
