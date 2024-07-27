@isTest
private class VNOS_DOMAIN_CommercialAttribute_Test {
  @isTest
  static void constructorCanCreateCommercialAttributeFromAMap() {
    //Given
    Map<String, Object> commercialAttributeMap = new Map<String, Object>();
    commercialAttributeMap.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_UNIQUE_CODE,
      'VNOS_ATT_DATA'
    );
    commercialAttributeMap.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_DISPLAY_NAME,
      'Dados'
    );
    commercialAttributeMap.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_VALUE,
      '3 GB'
    );

    //When
    VNOS_DOMAIN_CommercialAttribute commercialAttribute = new VNOS_DOMAIN_CommercialAttribute(
      commercialAttributeMap
    );

    //Then
    System.assertEquals(
      commercialAttributeMap.get(
        VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_UNIQUE_CODE
      ),
      commercialAttribute.code(),
      'The code was not set properly'
    );
    System.assertEquals(
      commercialAttributeMap.get(
        VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_DISPLAY_NAME
      ),
      commercialAttribute.name(),
      'The name was not set properly'
    );
    System.assertEquals(
      commercialAttributeMap.get(VNOS_DOMAIN_CommercialAttribute.CONST_VALUE),
      commercialAttribute.value(),
      'The value was not set properly'
    );
  }

  @isTest
  static void compareToReturns0WhenTheAttributeHaveTheSameDisplaySequence() {
    //Given
    VNOS_DOMAIN_CommercialAttribute commercialAttribute = new VNOS_DOMAIN_CommercialAttribute();
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      20
    );
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT,
      true
    );

    VNOS_DOMAIN_CommercialAttribute compareTo = new VNOS_DOMAIN_CommercialAttribute();
    compareTo.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      20
    );
    compareTo.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, true);
    //When
    Integer result = commercialAttribute.compareTo(compareTo);

    //Then
    System.assert(
      result == 0,
      'result need to be 0 when they have same display sequence'
    );
  }
  @isTest
  static void compareToReturns1WhenTheAttributeHaveBiggerDisplaySequence() {
    //Given
    VNOS_DOMAIN_CommercialAttribute commercialAttribute = new VNOS_DOMAIN_CommercialAttribute();
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      30
    );
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT,
      true
    );
    VNOS_DOMAIN_CommercialAttribute compareTo = new VNOS_DOMAIN_CommercialAttribute();
    compareTo.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      20
    );
    compareTo.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, true);

    //When
    Integer result = commercialAttribute.compareTo(compareTo);

    //Then
    System.assert(
      result == 1,
      'result need to be 1 when they have bigger display sequence'
    );
  }

  @isTest
  static void compareToReturnsMinus1WhenTheAttributeHaveSmallerDisplaySequence() {
    //Given
    VNOS_DOMAIN_CommercialAttribute commercialAttribute = new VNOS_DOMAIN_CommercialAttribute();
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      10
    );
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT,
      true
    );
    VNOS_DOMAIN_CommercialAttribute compareTo = new VNOS_DOMAIN_CommercialAttribute();
    compareTo.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_MATRIX_DISPLAY_SEQUENCE,
      20
    );
    compareTo.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, true);

    //When
    Integer result = commercialAttribute.compareTo(compareTo);

    //Then
    System.assert(
      result == -1,
      'result need to be -1 when they have bigger display sequence'
    );
  }

  @isTest
  static void valueSetter() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_VALUE, '1GB');

    //When
    attribute.value('2GB');

    //Then
    System.assert(
      attribute.value().equals('2GB'),
      attribute.value() + 'is different than 2GB'
    );
  }

  @isTest
  static void isInputReturnTrueWhenAttributeIsInput() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, 'true');

    //When
    Boolean isInput = attribute.isInput();

    //Then
    System.assert(isInput, 'result should be true');
  }

  @isTest
  static void isInputReturnFalseWhenAttributeIsNotInput() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, 'false');

    //When
    Boolean isInput = attribute.isInput();

    //Then
    System.assert(!isInput, 'result should be false');
  }

  @isTest
  static void isInputSetter() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(VNOS_DOMAIN_CommercialAttribute.CONST_IS_INPUT, 'false');

    //When
    attribute.isInput(true);

    //Then
    System.assert(
      attribute.isInput(),
      attribute.isInput() + '  should be true'
    );
  }

  @isTest
  static void isFromMatrixReturnTrueWhenAttributeIsFromMatrix() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_FROM_MATRIX,
      'true'
    );

    //When
    Boolean isFromMatrix = attribute.isFromMatrix();

    //Then
    System.assert(isFromMatrix, 'result should be true');
  }

  @isTest
  static void isFromMatrixReturnFalseWhenAttributeIsNotFromMatrix() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_FROM_MATRIX,
      'false'
    );

    //When
    Boolean isFromMatrix = attribute.isFromMatrix();

    //Then
    System.assert(!isFromMatrix, 'result should be false');
  }

  @isTest
  static void isFromMatrixSetter() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();
    attribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_IS_FROM_MATRIX,
      'false'
    );

    //When
    attribute.isFromMatrix(true);

    //Then
    System.assert(
      attribute.isFromMatrix(),
      attribute.isFromMatrix() + '  should be true'
    );
  }
  @isTest
  static void displaySequenceReturns0IfAnExceptionOccurs() {
    //Given
    VNOS_DOMAIN_CommercialAttribute attribute = new VNOS_DOMAIN_CommercialAttribute();

    attribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTED_DISPLAY_SEQUENCE,
      'definetly not an integer'
    );

    //When
    Integer sequence = attribute.displaySequence();

    //Then
    System.assert(sequence == 0, 'sequence should be equal to 0');
  }
  @isTest
  static void toResponseNeedsToReturnAMapRepresentationOfTheCommercialAttribute() {
    //Given
    Map<String, Object> value = new Map<String, Object>();
    value.put(VNOS_DOMAIN_CommercialAttribute.OUTPUT_VALUE, '10GB');
    value.put(VNOS_DOMAIN_CommercialAttribute.CONST_DISPLAY_TEXT, '10 GB');

    List<Object> values = new List<Object>{ value };

    Map<String, Object> attributesRuntimeInfo = new Map<String, Object>();
    attributesRuntimeInfo.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_VALUES,
      values
    );

    VNOS_DOMAIN_CommercialAttribute commercialAttribute = new VNOS_DOMAIN_CommercialAttribute();
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_VALUE_DATA_TYPE,
      VNOS_DOMAIN_CommercialAttribute.CONST_PICKLIST
    );
    commercialAttribute.node.put(
      VNOS_DOMAIN_CommercialAttribute.CONST_ATTRIBUTE_RUNTIME_INFO,
      attributesRuntimeInfo
    );
    commercialAttribute.value('10 GB');
    //When
    Map<String, Object> response = commercialAttribute.toResponse();

    //Then
    System.assert(response != null, 'response should not be null');
    //TODO : better this test
  }
}
