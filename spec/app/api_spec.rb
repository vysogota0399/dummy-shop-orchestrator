RSpec.describe Api do
  def app
    described_class
  end

  API_PATH = '/api/v1'

  describe "POST #{API_PATH}" do
    let(:valid_order_params) do 
      {
        order: {
          customer_id: 1,
          customer_email: 'test@mail.ru',
          address: 'msk',
          front_door: '1',
          floor: '1',
          intercom: '1',
          item_ids: [],
        }
      }
    end
    describe "/orders" do
      context 'when request data valid' do
        it 'returns a successful response' do
          post("#{API_PATH}/orders", valid_order_params.to_json)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when request data invalid' do
        before { post("#{API_PATH}/orders", { fiz: :baz }.to_json) }
        it 'returns bad request' do
          expect(last_response.status).to eq(400)
        end
      end
    end

    describe "POST #{API_PATH}/items/filter" do
      context "when orders exists" do
        before do
          create(:item)
          post("#{API_PATH}/items/filter", {}.to_json)
        end
        let(:response_body) { JSON.load(last_response.body) }

        it 'returns a successful response' do
          expect(last_response.status).to eq(200)
        end

        it 'returns response whith correct meta' do
          expect(response_body).to have_key('meta')
          expect(response_body['meta'].keys).to contain_exactly('count', 'page', 'items')
        end

        it 'returns response whith correct data' do
          expect(response_body).to have_key('data')
          expect(response_body['data']).to be_instance_of(Array)
        end
      end
      
      context "when orders not exists" do
        before do
          post("#{API_PATH}/items/filter", { id: -1 }.to_json)
        end
        let(:response_body) { JSON.load(last_response.body) }

        it 'returns a successful response' do
          expect(last_response.status).to eq(200)
        end

        it 'returns response whith correct data' do
          expect(response_body).to have_key('data')
          expect(response_body['data']).to be_instance_of(Array)
          expect(response_body['data']).to be_empty
        end

        it 'returns response whith correct meta' do
          expect(response_body).to have_key('meta')
          expect(response_body['meta'].keys).to contain_exactly('count', 'page', 'items')
          expect(response_body.dig('meta', 'count')).to eq(0)
        end
      end
    end
    

    describe "POST #{API_PATH}/validate" do
      it 'returns a successful response' do
        post("#{API_PATH}/orders/validate", valid_order_params.to_json)
        expect(last_response.status).to eq(200)
      end
    end
  end


  describe "GET #{API_PATH}/orders" do
    before do
      create(:order)
    end
    describe "/:id" do
      context 'when order exists' do
        it 'returns currect order' do
          expected_order = Order.first
          get("#{API_PATH}/orders/#{expected_order.id}")
          response = JSON.parse(last_response.body)

          actual_id = response.dig('data', 'id')
          expect(actual_id).to eq(expected_order.id)
        end
  
        it 'returns a successful response' do
          order = Order.first
          get("#{API_PATH}/orders/#{order.id}")

          expect(last_response.status).to eq(200)
        end
      end
  
      context 'when order does not exist' do
        it 'returns 404' do
          get "#{API_PATH}/orders/-1"
          expect(last_response.status).to eq(404)
        end
      end
    end
  end
end