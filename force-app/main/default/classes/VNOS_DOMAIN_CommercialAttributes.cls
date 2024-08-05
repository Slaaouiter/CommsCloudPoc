public class VNOS_DOMAIN_CommercialAttributes {
  @TestVisible
  private static final String ACAT_COMMERCIAL = 'ACAT_COMMERCIAL';
  @TestVisible
  private static final String CONST_ATTRIBUTE_SEPARATOR = ';';
  @TestVisible
  private static final String CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME = 'Matriz de Preços';

  public List<VNOS_DOMAIN_CommercialAttribute> elements = new List<VNOS_DOMAIN_CommercialAttribute>();

  public Map<String, VNOS_DOMAIN_CommercialAttribute> displayNameToCommercialAttribute = new Map<String, VNOS_DOMAIN_CommercialAttribute>();

  public VNOS_DOMAIN_CommercialAttributes() {
  }

  public VNOS_DOMAIN_CommercialAttributes(
    Map<String, Object> attributeCategory
  ) {
    if (
      attributeCategory != null &&
      attributeCategory.containsKey(ACAT_COMMERCIAL)
    ) {
      List<Object> commercialAttributes = (List<Object>) attributeCategory.get(
        ACAT_COMMERCIAL
      );
      for (Object commercialAttribute : commercialAttributes) {
        VNOS_DOMAIN_CommercialAttribute element = new VNOS_DOMAIN_CommercialAttribute(
          (Map<String, Object>) commercialAttribute
        );
        elements.add(element);
        displayNameToCommercialAttribute.put(element.name(), element); // TODO : Once the matrix is updated to using only codes, this map needs to be codeToCommercialAttribute
      }
    }
  }

  public void updateFromMatrixRow(VNOS_DOMAIN_AttributePricingMatrixRow row) {
    updateAttributes(row.characteristicName, row.characteristicValue, true);
    updateAttributes(
      row.targetCharacteristicName,
      row.targetCharacteristicValue,
      false
    );
  }
  private void updateAttributes(String names, String values, Boolean isInput) {
    if (String.isNotBlank(names) && String.isNotBlank(values)) {
      List<String> attributesNames = names.split(CONST_ATTRIBUTE_SEPARATOR);
      List<String> attributesValues = values.split(CONST_ATTRIBUTE_SEPARATOR);
      for (Integer index = 0; index < attributesNames.size(); index++) {
        String value = (attributesValues.size() > index)
          ? attributesValues.get(index)
          : '';
        updateAttribute(index, attributesNames.get(index), value, isInput);
      }
    }
  }
  private void updateAttribute(
    Integer sequenceIndex,
    String name,
    String value,
    Boolean isInput
  ) {
    if (displayNameToCommercialAttribute.containsKey(name)) {
      VNOS_DOMAIN_CommercialAttribute attribute = displayNameToCommercialAttribute.get(
        name
      );
      attribute.value(value);
      attribute.isInput(isInput);
      attribute.isFromMatrix(true);
      attribute.matrixDisplaySequence(sequenceIndex);
    }
  }

  public VNOS_DOMAIN_CommercialAttributes getCommercialAttributesComingFromMatrix() {
    VNOS_DOMAIN_CommercialAttributes commercialAttributes = new VNOS_DOMAIN_CommercialAttributes();
    for (VNOS_DOMAIN_CommercialAttribute commercialAttribute : elements) {
      if (commercialAttribute.isFromMatrix()) {
        commercialAttributes.elements.add(commercialAttribute);
      }
    }
    return commercialAttributes;
  }

  public VNOS_DOMAIN_CommercialAttribute getPricingMatrixAttribute(){
    return this.displayNameToCommercialAttribute.containsKey(CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME)? this.displayNameToCommercialAttribute.get(CONST_ATTRIBUTE_PRICING_MATRIX_DISPLAY_NAME) : null;
  }

  public List<Object> toResponse() {
    List<Object> response = new List<Object>();
    for (VNOS_DOMAIN_CommercialAttribute commercialAttribute : elements) {
      response.add(commercialAttribute.toResponse());
    }
    return response;
  }
}