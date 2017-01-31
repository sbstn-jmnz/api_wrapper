require 'api_wrapper'

describe ApiWrapper::PurchaseOrders do
  let(:handler) {ApiWrapper::PurchaseOrders.new}
    it 'Obtiene una orden de compra por su codigo' do
      po = handler.get_po('2097-241-SE14')
      expect(po).to be_an_instance_of(Hash)
      expect(po).to include('Listado')
      expect(po['Listado'][0]).to include('Proveedor')
      expect(po['Listado'][0]).to include('Comprador')
      expect(po['Listado'][0]).to include('Items')
    end

    it 'Obtiene ordenes de compra por organismo y fecha' do
      entity_code = '113812'
      date = Date.new(2014,3,2)
      pos = handler.get_pos_by_entity_and_date(entity_code,date)
      expect(pos).to be_an_instance_of(Array)
      expect(pos[0]).to be_an_instance_of(Hash)
      expect(pos[0]).to include("Codigo")
    end

    it 'Obtiene ordenes de compra por proveedor y fecha' do
      seller_code = '200239'
      date = Date.new(2014,3,7)
      pos = handler.get_pos_by_seller_and_date(seller_code,date)
      expect(pos).to be_an_instance_of(Array)
      expect(pos[0]).to be_an_instance_of(Hash)
      expect(pos[0]).to include("Codigo")
    end
end

describe ApiWrapper::Seller do
  let(:handler) {ApiWrapper::Seller.new}
  it 'Obtiene el codigo de proveedor por su rut' do
    seller_code = '70.017.820-k'
    seller = handler.get_seller_hash(seller_code)
    expect(seller).to be_an_instance_of(Hash)
  end

end
