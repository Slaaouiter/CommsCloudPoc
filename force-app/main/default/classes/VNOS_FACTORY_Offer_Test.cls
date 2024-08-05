@isTest
private class VNOS_FACTORY_Offer_Test {
  @isTest
  static void createOfferCreatesAProductIfTheOfferTypeIsProduct() {
    //Given
    Map<String, Object> offerMap = new Map<String, Object>();
    offerMap.put(VNOS_FACTORY_Offer.CONST_OFFER_TYPE, 'Product');

    //When
    VNOS_DOMAIN_Offer offer = VNOS_FACTORY_Offer.createOffer(offerMap);

    //Then
    System.assert(
      offer instanceof VNOS_DOMAIN_Product,
      'It should be a product'
    );
  }
  @isTest
  static void createOfferCreatesAProductIfTheOfferTypeIsPromotion() {
    //Given
    Map<String, Object> offerMap = new Map<String, Object>();
    offerMap.put(VNOS_FACTORY_Offer.CONST_OFFER_TYPE, 'Promotion');

    //When
    VNOS_DOMAIN_Offer offer = VNOS_FACTORY_Offer.createOffer(offerMap);

    //Then
    System.assert(
      offer instanceof VNOS_DOMAIN_Promotion,
      'It should be a promotion'
    );
  }
}
