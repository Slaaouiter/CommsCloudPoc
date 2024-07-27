@isTest
private class VNOS_DOMAIN_Promotions_Test {
  @isTest
  static void constructorCanCreatePromotionsFromOffers() {
    //Given
    List<VNOS_DOMAIN_Offer> offers = new List<VNOS_DOMAIN_Offer>();
    offers.add(new VNOS_DOMAIN_Promotion());
    offers.add(new VNOS_DOMAIN_Promotion());
    offers.add(new VNOS_DOMAIN_Product());

    //When
    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions(offers);

    //Then
    System.assert(promotions.elements.size() == 2, 'Elements Size != 2');
  }

  @isTest
  static void constructorCanCreatePromotionsFromListOfObject() {
    //Given
    List<Object> promotionsNodes = new List<Object>();
    promotionsNodes.add(new Map<String, Object>());
    promotionsNodes.add(new Map<String, Object>());

    //When
    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions(
      promotionsNodes
    );

    //Then
    System.assert(promotions.elements.size() == 2, 'Elements Size != 2');
  }

  @isTest
  static void groupByProductCode() {
    //Given
    Map<String, String> productCodeToContextProductCode = new Map<String, String>();
    productCodeToContextProductCode.put('UZO', 'UZO');
    productCodeToContextProductCode.put('MEO', 'MEO');

    VNOS_DOMAIN_Product uzoMobile = new VNOS_DOMAIN_Product();
    uzoMobile.node.put(VNOS_DOMAIN_Product.CONST_CODE, 'UZO');

    VNOS_DOMAIN_Product meoMobile = new VNOS_DOMAIN_Product();
    meoMobile.node.put(VNOS_DOMAIN_Product.CONST_CODE, 'MEO');

    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.products.elements.add(uzoMobile);

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.products.elements.add(uzoMobile);
    oneMonthFree.products.elements.add(meoMobile);

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);

    //When
    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions = promotions.groupByProductCode(
      productCodeToContextProductCode
    );

    //Then
    System.assert(
      productCodeToPromotions.size() == 2,
      'map should contain 2 entries'
    );

    System.assert(
      productCodeToPromotions.containsKey('UZO'),
      'map should contains UZO key'
    );
    System.assert(
      productCodeToPromotions.get('UZO').elements.size() == 2,
      'uzo related promotions size should be 2'
    );

    System.assert(
      productCodeToPromotions.containsKey('MEO'),
      'map should contains MEO key'
    );
    System.assert(
      productCodeToPromotions.get('MEO').elements.size() == 1,
      'meo related promotions size should be 1'
    );
  }

  @isTest
  static void groupByBrowseHighlightingPosition() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center;Top'
    );

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center;Below First Attribute'
    );

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();
    fedilization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Below First Attribute'
    );

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    Map<String, VNOS_DOMAIN_Promotions> positionToPromotions = promotions.groupByBrowseHighlightingPosition();

    //Then
    System.assert(
      positionToPromotions.size() == 3,
      'map should contain 3 entries'
    );

    System.assert(
      positionToPromotions.containsKey('Center'),
      'map should contains Center key'
    );
    System.assert(
      positionToPromotions.get('Center').elements.size() == 2,
      'center related promotions size should be 2'
    );

    System.assert(
      positionToPromotions.containsKey('Top'),
      'map should contains Top key'
    );
    System.assert(
      positionToPromotions.get('Top').elements.size() == 1,
      'top related promotions size should be 1'
    );

    System.assert(
      positionToPromotions.containsKey('BelowFirstAttribute'),
      'map should contains BelowFirstAttribute key'
    );
    System.assert(
      positionToPromotions.get('BelowFirstAttribute').elements.size() == 2,
      'belowFirstAttribute related promotions size should be 2'
    );
  }

  @isTest
  static void getAutoAppliedPromotions() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    VNOS_DOMAIN_Promotions autoAppliedPromotions = promotions.getAutoAppliedPromotions();

    //Then
    System.assert(
      autoAppliedPromotions != null,
      'autoAppliedPromotions should not be null'
    );
    System.assert(
      autoAppliedPromotions.elements.size() == 1,
      'autoAppliedPromotions should have one element'
    );
  }

  @isTest
  static void getAutoAppliedPromotionsAtBrowseOffer() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Order Submit'
    );

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();
    fedilization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );
    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    VNOS_DOMAIN_Promotions autoAppliedPromotions = promotions.getAutoAppliedPromotionsAtBrowseOffer();

    //Then
    System.assert(
      autoAppliedPromotions != null,
      'autoAppliedPromotions should not be null'
    );
    System.assert(
      autoAppliedPromotions.elements.size() == 2,
      'autoAppliedPromotions should have two element'
    );
  }
  @isTest
  static void ids() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_ID_C, '1');
    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_ID_C, '2');

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();
    fedilization.node.put(VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_ID_C, '3');

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);
    //When
    Set<String> result = promotions.ids();
    //Then
    System.assert(
      result != null && !result.isEmpty() && result.size() == 3,
      'result should contain 3 ids not ' + result.size()
    );
  }
  @isTest
  static void filterByOfferVariant() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '1GB_500MB;2GB_500MB'
    );
    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '2GB_500MB;3GB_500MB'
    );

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();
    fedilization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '1GB_500MB'
    );

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    VNOS_DOMAIN_Promotions results = promotions.filterByOfferVariant(
      '3GB_500MB'
    );
    //Then
    System.assert(
      results != null &&
        !results.elements.isEmpty() &&
        results.elements.size() == 1,
      'result should contain 1 elements'
    );
    System.assert(
      results.elements.get(0) == oneMonthFree,
      ' the element should be oneMonthFree'
    );
  }
  @isTest
  static void toResponse() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    List<Object> response = promotions.toResponse();

    //Then
    System.assert(
      response != null && response.size() == 3,
      'response should contain 3 elements'
    );
  }

  @isTest
  static void getAutoAppliedPromotionsGroupedByPositionResponse() {
    //Given
    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center;Top'
    );
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center;Below First Attribute'
    );
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Order Submit'
    );

    VNOS_DOMAIN_Promotion fedilization = new VNOS_DOMAIN_Promotion();
    fedilization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Below First Attribute'
    );
    fedilization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );

    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements.add(electronicInvoice);
    promotions.elements.add(oneMonthFree);
    promotions.elements.add(fedilization);

    //When
    Map<String, Object> response = promotions.getAutoAppliedPromotionsGroupedByPositionResponse();

    //Then
    System.assert(response.size() == 3, 'map should contain 3 entries');

    System.assert(
      response.containsKey('Center'),
      'map should contains Center key'
    );

    System.assert(response.containsKey('Top'), 'map should contains Top key');

    System.assert(
      response.containsKey('BelowFirstAttribute'),
      'map should contains BelowFirstAttribute key'
    );
  }
}
