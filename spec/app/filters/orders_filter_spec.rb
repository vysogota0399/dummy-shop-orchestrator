RSpec.describe 'OrdersFilter' do
  let(:filter) { Orchestrator['orders_filter'] }

  describe "#call" do
    context "when filter is empty" do
      it "returns relation" do
        expect(filter.call).to eq(Order.all)
      end
    end
  end
end