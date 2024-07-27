public class VNOS_DOMAIN_CommercialAttribute implements Comparable {
  @TestVisible
  private static final String CONST_ATTRIBUTE_UNIQUE_CODE = 'attributeuniquecode__c';
  @TestVisible
  private static final String CONST_ATTRIBUTE_DISPLAY_NAME = 'attributedisplayname__c';
  @TestVisible
  private static final String CONST_ATTRIBUTED_DISPLAY_SEQUENCE = 'attributedisplaysequence__c';
  @TestVisible
  private static final String CONST_VALUE = 'value__c';
  @TestVisible
  private static final String CONST_VALUE_DATA_TYPE = 'valuedatatype__c';
  @TestVisible
  private static final String CONST_PICKLIST = 'Picklist';
  @TestVisible
  private static final String CONST_VALUES = 'values';
  @TestVisible
  private static final String CONST_DISPLAY_TEXT = 'displayText';
  @TestVisible
  private static final String CONST_MATRIX_DISPLAY_SEQUENCE = 'matrixDisplaySequence';
  @TestVisible
  private static final String CONST_IS_FROM_MATRIX = 'isFromMatrix';
  @TestVisible
  private static final String CONST_IS_INPUT = 'isInput';
  @TestVisible
  private static final String CONST_ATTRIBUTE_RUNTIME_INFO = 'attributeRunTimeInfo';
  @TestVisible
  private static final String OUTPUT_VALUE = 'value';
  @TestVisible
  private static final String OUTPUT_RUNTIME_VALUE = 'runtimeValue';
  @TestVisible
  private static final String OUTPUT_CODE = 'code';
  @TestVisible
  private static final String OUTPUT_NAME = 'name';

  public Map<String, Object> node = new Map<String, Object>();

  public VNOS_DOMAIN_CommercialAttribute() {
  }

  public VNOS_DOMAIN_CommercialAttribute(
    Map<String, Object> commercialAttribute
  ) {
    if (commercialAttribute != null) {
      this.node = commercialAttribute;
    }
  }

  public String code() {
    return String.valueOf(node.get(CONST_ATTRIBUTE_UNIQUE_CODE));
  }

  public String name() {
    return String.valueOf(node.get(CONST_ATTRIBUTE_DISPLAY_NAME));
  }

  public String value() {
    return String.valueOf(node.get(CONST_VALUE));
  }

  public void value(String value) {
    node.put(CONST_VALUE, value);
  }

  public void matrixDisplaySequence(Integer sequence) {
    node.put(CONST_MATRIX_DISPLAY_SEQUENCE, sequence);
  }

  public Integer matrixDisplaySequence() {
    Integer matrixDisplaySequence = 0;
    try {
      matrixDisplaySequence = Integer.valueOf(
        node.get(CONST_MATRIX_DISPLAY_SEQUENCE)
      );
    } catch (Exception e) {
      System.debug(
        'The matrix display sequence of the attribute' +
          code() +
          ' has an invalid integer value'
      );
    }
    return matrixDisplaySequence;
  }

  public Boolean isDataTypePicklist() {
    return CONST_PICKLIST.equals(node.get(CONST_VALUE_DATA_TYPE));
  }

  public Boolean isInput() {
    return node.containsKey(CONST_IS_INPUT)
      ? Boolean.valueOf(node.get(CONST_IS_INPUT))
      : false;
  }
  public void isInput(Boolean isInput) {
    node.put(CONST_IS_INPUT, String.valueOf(isInput));
  }

  public Boolean isFromMatrix() {
    return node.containsKey(CONST_IS_FROM_MATRIX)
      ? Boolean.valueOf(node.get(CONST_IS_FROM_MATRIX))
      : false;
  }
  public void isFromMatrix(Boolean isFromMatrix) {
    node.put(CONST_IS_FROM_MATRIX, isFromMatrix);
  }

  public Integer displaySequence() {
    Integer displaySequence = 0;
    try {
      displaySequence = Integer.valueOf(
        node.get(CONST_ATTRIBUTED_DISPLAY_SEQUENCE)
      );
    } catch (Exception e) {
      System.debug(
        'The display sequence of the attribute' +
          code() +
          ' has an invalid integer value'
      );
    }
    return displaySequence;
  }

  public Integer compareTo(Object compareTo) {
    VNOS_DOMAIN_CommercialAttribute compareToCommercialAttribute = (VNOS_DOMAIN_CommercialAttribute) compareTo;
    Boolean bothInputs = isInput() && compareToCommercialAttribute.isInput();
    Boolean bothNonInputs =
      !isInput() && !compareToCommercialAttribute.isInput();
    Boolean haveSameInputStatus = bothInputs || bothNonInputs;

    if (haveSameInputStatus) {
      return compareBasedOnMatrixDisplaySequence(compareToCommercialAttribute);
    }

    return isInput() ? -1 : 1; //I don't know why , it should be logically isInput() ? 1 : -1 but it sorts somehow in different direction when it's the case.
  }

  public Integer compareBasedOnMatrixDisplaySequence(
    VNOS_DOMAIN_CommercialAttribute compareToCommercialAttribute
  ) {
    return (matrixDisplaySequence() ==
      compareToCommercialAttribute.matrixDisplaySequence())
      ? 0
      : (matrixDisplaySequence() >
          compareToCommercialAttribute.matrixDisplaySequence())
          ? 1
          : -1;
  }

  public VNOS_DOMAIN_AttributesRunTimeInfo attributesRunTimeInfo() {
    if (node.containsKey(CONST_ATTRIBUTE_RUNTIME_INFO)) {
      Object attributesRuntimeInfo = node.get(CONST_ATTRIBUTE_RUNTIME_INFO);
      if (
        attributesRuntimeInfo != null &&
        attributesRuntimeInfo instanceof Map<String, Object>
      ) {
        return new VNOS_DOMAIN_AttributesRunTimeInfo(
          (Map<String, Object>) attributesRuntimeInfo
        );
      }
    }
    return null;
  }

  public String attributeRunTimeValue() {
    VNOS_DOMAIN_AttributesRunTimeInfo attributesRunTimeInfo = attributesRunTimeInfo();
    if (attributesRunTimeInfo != null) {
      VNOS_DOMAIN_AttributeRunTimeInfo attributeRunTimeInfo = attributesRunTimeInfo.find(
        value()
      );
      if (attributeRunTimeInfo != null) {
        return attributeRunTimeInfo.value();
      }
    }
    return null;
  }

  public Map<String, Object> toResponse() {
    Map<String, Object> response = new Map<String, Object>();
    response.put(OUTPUT_VALUE, value());
    response.put(OUTPUT_CODE, code());
    response.put(CONST_IS_INPUT, isInput());
    response.put(CONST_IS_FROM_MATRIX, isFromMatrix());
    response.put(CONST_ATTRIBUTED_DISPLAY_SEQUENCE, matrixDisplaySequence());
    response.put(OUTPUT_NAME, name());
    if (isDataTypePicklist()) {
      String runtimeValue = attributeRunTimeValue();
      if (String.isNotBlank(runtimeValue)) {
        response.put(OUTPUT_RUNTIME_VALUE, runtimeValue);
      }
    }
    return response;
  }

  class VNOS_DOMAIN_AttributesRunTimeInfo {
    public List<VNOS_DOMAIN_AttributeRunTimeInfo> elements = new List<VNOS_DOMAIN_AttributeRunTimeInfo>();

    public VNOS_DOMAIN_AttributesRunTimeInfo(
      Map<String, Object> attributesRunTimeInfo
    ) {
      if (
        attributesRunTimeInfo != null &&
        !attributesRunTimeInfo.isEmpty() &&
        attributesRunTimeInfo.containsKey(CONST_VALUES)
      ) {
        List<Object> values = (List<Object>) attributesRunTimeInfo.get(
          CONST_VALUES
        );
        for (Object value : values) {
          if (value instanceof Map<String, Object>) {
            elements.add(
              new VNOS_DOMAIN_AttributeRunTimeInfo((Map<String, Object>) value)
            );
          }
        }
      }
    }
    public VNOS_DOMAIN_AttributeRunTimeInfo find(String displayText) {
      if (String.isNotBlank(displayText)) {
        for (VNOS_DOMAIN_AttributeRunTimeInfo element : elements) {
          if (displayText.equals(element.displayText())) {
            return element;
          }
        }
      }
      return null;
    }
  }
  class VNOS_DOMAIN_AttributeRunTimeInfo {
    public Map<String, Object> node = new Map<String, Object>();
    public VNOS_DOMAIN_AttributeRunTimeInfo(
      Map<String, Object> attributeRunTimeInfo
    ) {
      if (attributeRunTimeInfo != null) {
        node = attributeRunTimeInfo;
      }
    }
    public String displayText() {
      return String.valueOf(node.get(CONST_DISPLAY_TEXT));
    }

    public String value() {
      return String.valueOf(node.get(OUTPUT_VALUE));
    }
  }
}
