@isTest
private class VNOS_DOMAIN_Products_Test {
  @isTest
  static void constructorCanCreateProductsFromListObject() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_NAME, 'UZO Móvel');
    productMap.put(VNOS_DOMAIN_Product.CONST_CODE, 'VNOS_OFFERING_UZO_MOBILE');

    List<Object> productsList = new List<Object>{ productMap };

    //When
    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products(productsList);

    //Then
    System.assert(products.elements.size() == 1, 'Size != 1');
  }

  @isTest
  static void constructorCanCreateProductsFromListOffers() {
    //Given
    VNOS_DOMAIN_Product uzoMobile = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Promotion descontoElectronica = new VNOS_DOMAIN_Promotion();

    List<VNOS_DOMAIN_Offer> offers = new List<VNOS_DOMAIN_Offer>();
    offers.add(uzoMobile);
    offers.add(descontoElectronica);

    //When
    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products(offers);

    //Then
    System.assert(products.elements.size() == 1, 'Size != 1');
  }

  @isTest
  static void groupByOrderOfGroup() {
    //Given
    VNOS_DOMAIN_Product product1 = new VNOS_DOMAIN_Product();
    product1.orderOfGroup(2);
    VNOS_DOMAIN_Product product2 = new VNOS_DOMAIN_Product();
    product2.orderOfGroup(1);
    VNOS_DOMAIN_Product product3 = new VNOS_DOMAIN_Product();
    product3.orderOfGroup(2);

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product1);
    products.elements.add(product2);
    products.elements.add(product3);

    //When
    Map<Integer, List<VNOS_DOMAIN_Product>> productsGroupedByOrderOfGroup = products.groupByOrderOfGroup();

    //Then
    System.assert(
      productsGroupedByOrderOfGroup.size() == 2,
      'Size :' + productsGroupedByOrderOfGroup.size() + ' != 2'
    );

    System.assert(
      productsGroupedByOrderOfGroup.get(1).size() == 1,
      'Element with order group 1 size :' +
        productsGroupedByOrderOfGroup.get(1).size() +
        ' != 1'
    );

    System.assert(
      productsGroupedByOrderOfGroup.get(2).size() == 2,
      'Element with order group 2 size :' +
        productsGroupedByOrderOfGroup.get(1).size() +
        ' != 2'
    );
  }
  @isTest
  static void autoApplyPromotionsAtBrowseOffer() {
    //Given
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product);

    //When
    products.autoApplyPromotionsAtBrowseOffer();

    //Then
    System.assert(products != null, 'products not null');
    //TODO : to be completed
  }

  @isTest
  static void toResponse() {
    //Given
    VNOS_DOMAIN_Product product1 = new VNOS_DOMAIN_Product();
    product1.orderOfGroup(2);
    VNOS_DOMAIN_Product product2 = new VNOS_DOMAIN_Product();
    product2.orderOfGroup(1);
    VNOS_DOMAIN_Product product3 = new VNOS_DOMAIN_Product();
    product3.orderOfGroup(2);

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product1);
    products.elements.add(product2);
    products.elements.add(product3);

    //When
    List<Object> response = products.toResponse();

    //Then
    System.assert(response != null, 'response should be != null');
    //TODO : to be completed
  }

  @isTest
  static void attributePricingMatrixNames() {
    //Given
    VNOS_DOMAIN_CommercialAttribute pricingMatrixAttribute1 = new VNOS_DOMAIN_CommercialAttribute();
    pricingMatrixAttribute1.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_VALUE, 'Matrix1');

    VNOS_DOMAIN_CommercialAttribute pricingMatrixAttribute2 = new VNOS_DOMAIN_CommercialAttribute();
    pricingMatrixAttribute2.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_VALUE, 'Matrix2');

    VNOS_DOMAIN_CommercialAttributes attributes1 = new VNOS_DOMAIN_CommercialAttributes();
    attributes1.elements.add(pricingMatrixAttribute1);
    attributes1.displayNameToCommercialAttribute.put(VNOS_DOMAIN_CommercialAttributes.CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME, pricingMatrixAttribute1);

    VNOS_DOMAIN_CommercialAttributes attributes2 = new VNOS_DOMAIN_CommercialAttributes();
    attributes2.elements.add(pricingMatrixAttribute1);
    attributes2.displayNameToCommercialAttribute.put(VNOS_DOMAIN_CommercialAttributes.CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME, pricingMatrixAttribute2);

    VNOS_DOMAIN_Product product1 = new VNOS_DOMAIN_Product();
    product1.attributes = attributes1;

    VNOS_DOMAIN_Product product2 = new VNOS_DOMAIN_Product();
    product2.attributes = attributes2;
    
    VNOS_DOMAIN_Product product3 = new VNOS_DOMAIN_Product();
    
    VNOS_DOMAIN_Product product4 = new VNOS_DOMAIN_Product();
    
    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product1);
    products.elements.add(product2);
    products.elements.add(product3);
    products.elements.add(product4);

    String defaultAttributePricingMatrixName = 'AttributePricingMatrix';

    //When
    Set<String> names =  products.attributePricingMatrixNames(defaultAttributePricingMatrixName);

    //Then
    System.assert(names != null && !names.isEmpty(),'names should not be empty or null');
    System.assert(names.contains(pricingMatrixAttribute1.value()),'names should contains matrix1 but only have'+names);
    System.assert(names.contains(pricingMatrixAttribute2.value()),'names should contains matrix2 but only have'+names);
    System.assert(names.contains(defaultAttributePricingMatrixName),'names should contains matrix2 but only have'+names);
  }
}
