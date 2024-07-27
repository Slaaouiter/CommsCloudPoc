@isTest
private class VNOS_DOMAIN_Offers_Test {
  @isTest
  static void constructorCanCreateOffersFromListObject() {
    //Given
    Map<String, Object> offerMap = new Map<String, Object>();
    offerMap.put(VNOS_DOMAIN_Product.CONST_NAME, 'UZO Móvel');
    offerMap.put(VNOS_DOMAIN_Product.CONST_CODE, 'VNOS_OFFERING_UZO_MOBILE');
    offerMap.put(VNOS_FACTORY_Offer.CONST_OFFER_TYPE, 'Product');

    List<Object> offersList = new List<Object>{ offerMap };

    //When
    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers(offersList);

    //Then
    System.assert(offers.elements.size() == 1, 'Size != 1');
  }

  @isTest
  static void getPromotions() {
    //Given
    VNOS_DOMAIN_Offer promotion = new VNOS_DOMAIN_Promotion();
    VNOS_DOMAIN_Offer product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers();
    offers.elements.add(product);
    offers.elements.add(promotion);

    //When
    VNOS_DOMAIN_Promotions promotions = offers.getPromotions();

    //Then
    System.assert(
      promotions != null && promotions.elements.size() == 1,
      'promotions should not be null and should have one element'
    );
    System.assert(
      promotions.elements.get(0) == promotion,
      'it should contain the promotion'
    );
  }

  @isTest
  static void getProducts() {
    //Given
    VNOS_DOMAIN_Offer promotion = new VNOS_DOMAIN_Promotion();
    VNOS_DOMAIN_Offer product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers();
    offers.elements.add(product);
    offers.elements.add(promotion);

    //When
    VNOS_DOMAIN_Products products = offers.getProducts();

    //Then
    System.assert(
      products != null && products.elements.size() == 1,
      'products should not be null and should have one element'
    );
    System.assert(
      products.elements.get(0) == product,
      'it should contain the product'
    );
  }

  @isTest
  static void applyVAT() {
    //Given
    VNOS_DOMAIN_Offer promotion = new VNOS_DOMAIN_Promotion();
    VNOS_DOMAIN_Offer product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers();
    offers.elements.add(product);
    offers.elements.add(promotion);

    //When
    offers.applyVAT();

    //Then
    System.assert(offers != null, 'offer should not be null');
    //TODO need more testing
  }

  @isTest
  static void add() {
    //Given
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers();

    //When
    offers.add(product);

    //Then
    System.assert(
      offers.nodes.contains(product.node),
      'offers node should contain product node'
    );
    System.assert(
      offers.elements.contains(product),
      'offers elements should contain product'
    );
  }

  @isTest
  static void remove() {
    //Given
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();

    VNOS_DOMAIN_Offers offers = new VNOS_DOMAIN_Offers();
    offers.add(product);

    //When
    offers.remove(product);

    //Then
    System.assert(
      !offers.nodes.contains(product.node),
      'offers node should not contain product node'
    );
    System.assert(
      !offers.elements.contains(product),
      'offers elements should not contain product'
    );
  }
}
