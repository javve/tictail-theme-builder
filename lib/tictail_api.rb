class Tictail_api
  attr_accessor :agent, :store_id

  def initialize(agent, store_id)
    @agent = agent
    @store_id = store_id
  end

  def get(method)
    url = 'https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0","method":"' + method + '","params":{"store_id":' + @store_id.to_s + '},"id":null}'
    data = @agent.get(url).body
    data = JSON.parse(data)
    data["result"]
  end

  def get_full(method)
    url = 'https://tictail.com/apiv2/rpc/v1/?jsonrpc=' + method
    data = @agent.get(url).body
    data = JSON.parse(data)
    data["result"]
  end
end
