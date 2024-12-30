class JiraCheckout < Formula
  desc 'Checkout to branch from Jira'
  homepage 'https://github.com/krzysztoff1/homebrew-jira-checkout'
  version '1.0.0'

  url 'https://github.com/krzysztoff1/homebrew-jira-checkout/archive/main.zip', :using => :curl

  def install
    bin.install 'bin/jira_checkout'
  end
end
