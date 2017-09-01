class Search < ActiveRecord::Base
  has_many :results, dependent: :destroy
  serialize :results, Array

  def execute(index_page, count_pages)
    engines = "google|yahoo|bing"

    href = "http://127.0.0.1:9251/?action=search&keywords=#{keywords}&engines=#{engines}&index_page=#{index_page}&count_pages=#{count_pages}"
    logger.debug href
    s = Time.now

    results =RestClient.get href,
                            :content_type => :json,
                            :accept => :json

    delay = Time.now - s

    results = JSON.parse(results).to_a.sort { |a, b| b[1]['weight'] <=> a[1]['weight'] }

    while !(result = results.shift(1)).empty?
      @result = self.results.create!(:keywords => keywords,
                                        :results => result,
                                        :index => index_page,
                                        :count_results => result.count,
                                        :delay => delay)
    end
    @result
  end
end
