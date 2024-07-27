@isTest
private class VNOS_DOMAIN_Prices_Test {
  @isTest
  static void constructorCanCreatePricesFromAListOfObjects() {
    //Given
    List<Object> nodes = new List<Object>();
    nodes.add(new Map<String, Object>());

    //When
    VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices(nodes);

    //Then
    System.assert(
      prices != null && prices.elements.size() == 1,
      'elements should have one price'
    );
  }
  @isTest
  static void getPriceReturnsTheFirstPrice() {
    //Given
    Map<String, Object> priceNode = new Map<String, Object>();
    priceNode.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, 7.50);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(priceNode);

    VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices();
    prices.elements.add(price);

    //When
    VNOS_DOMAIN_Price firstPrice = prices.getPrice();

    //Then
    System.assertEquals(
      price.chargeAmount(),
      firstPrice.chargeAmount(),
      'The chargeAmount does not match the first price amount'
    );
  }

  @isTest
  static void updatePricesNeedsToUpdateTheAmountFromMonthlyRecurringChargeIfItIsAOneTimeCharge() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.mrc = '10';
    row.nrc = '20';

    Map<String, Object> priceNode = new Map<String, Object>();
    priceNode.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 7.50);
    priceNode.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_ONE_TIME
    );
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(priceNode);

    VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices();
    prices.elements.add(price);

    //When
    prices.updateAmountsFromMatrixRow(row);

    //Then
    System.assertEquals(
      row.nrc,
      price.amount(),
      'Update price needs to update the amount from the noneRecurringCharge'
    );
  }

  @isTest
  static void updatePricesNeedsToUpdateTheAmountFromNoneRecurringChargeIfItIsARecurringCharge() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.mrc = '10';
    row.nrc = '20';

    Map<String, Object> priceNode = new Map<String, Object>();
    priceNode.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 7.50);
    priceNode.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_RECURRING
    );
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(priceNode);

    VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices();
    prices.elements.add(price);

    //When
    prices.updateAmountsFromMatrixRow(row);

    //Then
    System.assertEquals(
      row.mrc,
      price.amount(),
      'Update price needs to update the amount from the noneRecurringCharge'
    );
  }
}
