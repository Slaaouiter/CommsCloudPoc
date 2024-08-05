@isTest
private class VNOS_DOMAIN_Offer_Test {
  @isTest
  static void constructorCanCreateOfferFromAMap() {
    //Given
    Map<String, Object> offerMap = new Map<String, Object>();
    offerMap.put(VNOS_DOMAIN_Offer.CONST_OFFER_TYPE, 'Product');

    //When
    VNOS_DOMAIN_Offer offer = new VNOS_DOMAIN_Offer(offerMap);

    //Then
    System.equals(
      offerMap.get(VNOS_DOMAIN_Offer.CONST_OFFER_TYPE),
      offer.offerType
    );
  }
  @isTest
  static void constructor() {
    //When
    VNOS_DOMAIN_Offer offer = new VNOS_DOMAIN_Offer();

    //Then

    System.assert(offer != null, 'offer not null');
  }
}
