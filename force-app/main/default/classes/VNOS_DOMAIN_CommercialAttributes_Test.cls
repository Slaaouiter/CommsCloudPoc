@isTest
private class VNOS_DOMAIN_CommercialAttributes_Test {
  @isTest
  static void constructorCanCreateCommercialAttributeFromListObject() {
    //Given
    Map<String, Object> commercialAttribute = new Map<String, Object>();
    commercialAttribute.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_DISPLAY_NAME,
      'Dados'
    );

    List<Object> commercialAttributes = new List<Object>();
    commercialAttributes.add(commercialAttribute);

    Map<String, Object> attributeCategory = new Map<String, Object>();

    attributeCategory.put(
      VNOS_DOMAIN_CommercialAttributes.ACAT_COMMERCIAL,
      commercialAttributes
    );

    //When
    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes(
      attributeCategory
    );

    //Then
    System.assert(
      attributes.elements.size() == 1,
      'attributes should contain one element'
    );
    System.assert(
      attributes.displayNameToCommercialAttribute.containsKey('Dados'),
      'The map should contain the key Dados'
    );
  }

  @isTest
  static void updateFromMatrixRow() {
    //Given
    VNOS_DOMAIN_CommercialAttribute dados = new VNOS_DOMAIN_CommercialAttribute();
    dados.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_DISPLAY_NAME,
      'Dados'
    );
    VNOS_DOMAIN_CommercialAttribute voice = new VNOS_DOMAIN_CommercialAttribute();
    voice.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_DISPLAY_NAME,
      'Voice/SMS'
    );

    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();
    attributes.displayNameToCommercialAttribute.put('Dados', dados);
    attributes.displayNameToCommercialAttribute.put('Voice/SMS', voice);

    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();

    row.characteristicName = 'Dados';
    row.characteristicValue = '10GB';

    row.targetCharacteristicName = 'Voice/SMS';
    row.targetCharacteristicValue = '1000Minutes';

    //When
    attributes.updateFromMatrixRow(row);

    //Then
    System.assert(
      attributes.displayNameToCommercialAttribute.get('Dados')
        .value()
        .equals('10GB'),
      'dados value should be 10GB'
    );
    System.assert(
      attributes.displayNameToCommercialAttribute.get('Dados').isInput(),
      'dados should be input'
    );
    System.assert(
      attributes.displayNameToCommercialAttribute.get('Dados').isFromMatrix(),
      'dados should be from matrix'
    );
    System.assert(
      attributes.displayNameToCommercialAttribute.get('Voice/SMS')
        .value()
        .equals('1000Minutes'),
      'voice value should be 1000Minutes'
    );
    System.assert(
      !attributes.displayNameToCommercialAttribute.get('Voice/SMS').isInput(),
      'voice should not be input'
    );
    System.assert(
      attributes.displayNameToCommercialAttribute.get('Voice/SMS')
        .isFromMatrix(),
      'voice should be from matrix'
    );
  }

  @isTest
  static void getCommercialAttributesComingFromMatrix() {
    //Given
    VNOS_DOMAIN_CommercialAttribute dados = new VNOS_DOMAIN_CommercialAttribute();
    dados.isFromMatrix(true);

    VNOS_DOMAIN_CommercialAttribute voice = new VNOS_DOMAIN_CommercialAttribute();
    voice.isFromMatrix(false);

    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();
    attributes.elements.add(dados);
    attributes.elements.add(voice);

    //When
    VNOS_DOMAIN_CommercialAttributes commercialAttributesComingFromMatrix = attributes.getCommercialAttributesComingFromMatrix();

    //Then
    System.assert(
      commercialAttributesComingFromMatrix.elements.size() == 1 &&
        commercialAttributesComingFromMatrix.elements.get(0) == dados,
      'should contain only dados attribute'
    );
  }

  @isTest
  static void toResponse() {
    //Given
    VNOS_DOMAIN_CommercialAttribute dados = new VNOS_DOMAIN_CommercialAttribute();

    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();
    attributes.elements.add(dados);

    //When
    List<Object> response = attributes.toResponse();

    //Then
    System.assert(
      response != null && response.size() == 1,
      'response not null and has one element'
    );
  }
  @isTest
  static void getPricingMatrixAttributeReturnNullIfAttributeIsNotFound(){
    //Given
    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();

    //When
    VNOS_DOMAIN_CommercialAttribute pricingMatrixAttribute = attributes.getPricingMatrixAttribute();

    //Then
    System.assert(pricingMatrixAttribute == null , 'pricingMatrixAttribute should be null');
  }

  @isTest
  static void getPricingMatrixAttribute(){
    //Given
    VNOS_DOMAIN_CommercialAttribute pricingMatrixAttribute = new VNOS_DOMAIN_CommercialAttribute();

    VNOS_DOMAIN_CommercialAttributes attributes = new VNOS_DOMAIN_CommercialAttributes();
    attributes.elements.add(pricingMatrixAttribute);
    attributes.displayNameToCommercialAttribute.put(VNOS_DOMAIN_CommercialAttributes.CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME, pricingMatrixAttribute);

    //When
    VNOS_DOMAIN_CommercialAttribute result = attributes.getPricingMatrixAttribute();

    //Then
    System.assert(result != null, 'result should not be null');
    System.assert(result == pricingMatrixAttribute, 'result should be the pricing matrix attribute');
  }
}
