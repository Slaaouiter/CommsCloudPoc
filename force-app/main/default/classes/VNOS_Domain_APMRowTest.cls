@isTest
private class VNOS_Domain_APMRowTest {
  @isTest
  static void constructorCanCreateFromACalculationMatrixRow() {
    //Given
    Map<String, Object> inputData = new Map<String, Object>();
    inputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_SOURCE_PRODUTC_NAME,
      'UZO Móvel'
    );
    inputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_SOURCE_PRODUTC_CODE,
      'VNOS_OFFERING_UZO_MOBILE'
    );
    inputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHARACTERISTIC_NAME,
      'Dados'
    );
    inputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHARACTERISTIC_VALUE,
      '6 GB'
    );

    Map<String, Object> outputData = new Map<String, Object>();
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHANNELS,
      'Portal'
    );
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_TARGET_CHARACTERISTIC_NAME,
      'Voz / SMS'
    );
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_TARGET_CHARACTERISTIC_VALUE,
      '500 minutos / SMS'
    );
    outputData.put(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_MRC, '8.5');
    outputData.put(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_NRC, '0');
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_ITEM_NAME,
      'UZO 500+500MB'
    );
    outputData.put(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_PITCH_ORDER, '1');
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_PUBLIC_OFFER_NAME,
      '500 OFFER'
    );
    outputData.put(
      VNOS_DOMAIN_AttributePricingMatrixRow.CONST_COMMERCIAL_DESCRIPTION,
      '500 messages and 500MB'
    );

    CalculationMatrixRow calculationMatrixRow = new CalculationMatrixRow();
    calculationMatrixRow.InputData = JSON.serialize(inputData);
    calculationMatrixRow.OutputData = JSON.serialize(outputData);

    //When
    VNOS_DOMAIN_AttributePricingMatrixRow attributePricingMatrixRow = new VNOS_DOMAIN_AttributePricingMatrixRow(
      calculationMatrixRow
    );

    //Then
    System.assertEquals(
      inputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_SOURCE_PRODUTC_NAME
      ),
      attributePricingMatrixRow.sourceProductName,
      'source product name is wrong'
    );
    System.assertEquals(
      inputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_SOURCE_PRODUTC_CODE
      ),
      attributePricingMatrixRow.sourceProductCode,
      'source product code is wrong'
    );

    System.assertEquals(
      inputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHARACTERISTIC_NAME
      ),
      attributePricingMatrixRow.characteristicName,
      'characteristic name is wrong'
    );
    System.assertEquals(
      inputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHARACTERISTIC_VALUE
      ),
      attributePricingMatrixRow.characteristicValue,
      'characteristic value is wrong'
    );
    System.assertEquals(
      outputData.get(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_CHANNELS),
      attributePricingMatrixRow.channels,
      'excluded channel is wrong'
    );
    System.assertEquals(
      outputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_TARGET_CHARACTERISTIC_NAME
      ),
      attributePricingMatrixRow.targetCharacteristicName,
      'target characteristic name is wrong'
    );
    System.assertEquals(
      outputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.CONST_TARGET_CHARACTERISTIC_VALUE
      ),
      attributePricingMatrixRow.targetCharacteristicValue,
      'target characteristic value is wrong'
    );
    System.assertEquals(
      outputData.get(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_MRC),
      attributePricingMatrixRow.mrc,
      'mrc is wrong'
    );
    System.assertEquals(
      outputData.get(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_NRC),
      attributePricingMatrixRow.nrc,
      'nrc is wrong'
    );

    System.assertEquals(
      outputData.get(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_ITEM_NAME),
      attributePricingMatrixRow.itemName,
      'item name is wrong'
    );
    System.assertEquals(
      outputData.get(VNOS_DOMAIN_AttributePricingMatrixRow.CONST_PITCH_ORDER),
      attributePricingMatrixRow.pitchOrder,
      'pitch order is wrong'
    );

    System.assertEquals(
      outputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_PUBLIC_OFFER_NAME
      ),
      attributePricingMatrixRow.publicOfferName,
      'public Offer Name  is wrong'
    );
    System.assertEquals(
      outputData.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_COMMERCIAL_DESCRIPTION
      ),
      attributePricingMatrixRow.commercialDescription,
      'commercial description  is wrong'
    );
  }
  @isTest
  static void getOrderForGroup() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.pitchOrder = '1-2';

    //When
    Integer orderForGroup = row.getOrderForGroup();

    //Then
    System.assert(orderForGroup == 1, orderForGroup + ' should be 1');
  }

  @isTest
  static void getOrderForGroupReturn0IfAnExceptionOccurs() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.pitchOrder = 'zzez';

    //When
    Integer orderForGroup = row.getOrderForGroup();

    //Then
    System.assert(orderForGroup == 0, orderForGroup + ' should be 0');
  }

  @isTest
  static void getOrderInGroup() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.pitchOrder = '1-2';

    //When
    Integer orderInGroup = row.getOrderInGroup();

    //Then
    System.assert(orderInGroup == 2, orderInGroup + ' should be 2');
  }

  @isTest
  static void getOrderInGroupReturn0IfAnExceptionOccurs() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.pitchOrder = '1-zaazaz';

    //When
    Integer orderInGroup = row.getOrderInGroup();

    //Then
    System.assert(orderInGroup == 0, orderInGroup + ' should be 0');
  }

  @isTest
  static void isEligibleForChannelReturnsFalseIfTheChannelIsNotPartOfTheChannels() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.channels = 'Web';

    String channel = 'Portal';

    //When
    Boolean isEligibleForChannel = row.isEligibleForChannel(channel);

    //Then
    System.assert(!isEligibleForChannel, 'Should not be eligible for channel');
  }
  @isTest
  static void isEligibleForChannelReturnsTrueIfTheChannelIsPartOfTheChannels() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.channels = 'Portal;Web';

    String channel = 'Portal';

    //When
    Boolean isEligibleForChannel = row.isEligibleForChannel(channel);

    //Then
    System.assert(isEligibleForChannel, 'Should be eligible for channel');
  }
  @isTest
  static void isEligibleForChannelReturnsFalseIfTheChannelsIsEmpty() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.channels = '';

    String channel = 'Portal';

    //When
    Boolean isEligibleForChannel = row.isEligibleForChannel(channel);

    //Then
    System.assert(!isEligibleForChannel, 'Should not be eligible for channel');
  }

  @isTest
  static void toResponse() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow attributePricingMatrixRow = new VNOS_DOMAIN_AttributePricingMatrixRow();
    attributePricingMatrixRow.sourceProductCode = 'VNOS_OFFERING_UZO_MOBILE';
    attributePricingMatrixRow.characteristicName = 'Dados';
    attributePricingMatrixRow.characteristicValue = '500 MB';
    attributePricingMatrixRow.mrc = '8.5';
    attributePricingMatrixRow.nrc = '0';
    attributePricingMatrixRow.publicOfferName = 'UZO';
    attributePricingMatrixRow.commercialDescription = 'UZO BEST OFFER';

    //When
    Map<String, Object> response = attributePricingMatrixRow.toResponse();

    //Then
    System.assertEquals(
      attributePricingMatrixRow.sourceProductCode,
      response.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_SOURCE_PRODUCT_CODE
      ),
      'Source product code is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.characteristicName,
      response.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_CHARACTERISTIC_NAME
      ),
      'Characteristic name is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.characteristicValue,
      response.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_CHARACTERISTIC_VALUE
      ),
      'Characteristic value is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.mrc,
      response.get(VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_MRC),
      'MRC value is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.nrc,
      response.get(VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_NRC),
      'NRC value is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.publicOfferName,
      response.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_PUBLIC_OFFER_NAME
      ),
      'publicOfferName value is not the same'
    );
    System.assertEquals(
      attributePricingMatrixRow.commercialDescription,
      response.get(
        VNOS_DOMAIN_AttributePricingMatrixRow.OUTPUT_COMMERCIAL_DESCRIPTION
      ),
      'commercial description value is not the same'
    );
  }
}
