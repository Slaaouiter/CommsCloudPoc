public class VNOS_DOMAIN_AttributePricingMatrixRow {
  @TestVisible
  private final static String CONST_SOURCE_PRODUTC_NAME = 'SourceProductName';
  @TestVisible
  private final static String CONST_SOURCE_PRODUTC_CODE = 'SourceProductCode';
  @TestVisible
  private final static String CONST_CHARACTERISTIC_NAME = 'CharacteristicName';
  @TestVisible
  private final static String CONST_CHARACTERISTIC_VALUE = 'CharacteristicValue';
  @TestVisible
  private final static String CONST_TARGET_CHARACTERISTIC_NAME = 'TargetCharacteristicName';
  @TestVisible
  private final static String CONST_TARGET_CHARACTERISTIC_VALUE = 'TargetCharacteristicValue';
  @TestVisible
  private final static String CONST_PITCH_ORDER = 'PitchOrder';
  @TestVisible
  private final static String CONST_ITEM_NAME = 'ItemName';
  @TestVisible
  private final static String CONST_MRC = 'MRC';
  @TestVisible
  private final static String CONST_NRC = 'NRC';
  @TestVisible
  private final static String CONST_CHANNELS = 'Channels';
  @TestVisible
  private final static String CONST_PUBLIC_OFFER_NAME = 'PublicOfferName';
  @TestVisible
  private final static String CONST_COMMERCIAL_DESCRIPTION = 'CommercialDescription';
  @TestVisible
  private final static String CONST_OFFER_VARIANT_CODE = 'OfferVariantCode';
  @TestVisible
  private final static String CONST_ORDERABLE = 'Orderable';

  @TestVisible
  private final static String OUTPUT_SOURCE_PRODUCT_CODE = 'sourceProductCode';
  @TestVisible
  private final static String OUTPUT_CHARACTERISTIC_NAME = 'characteristicName';
  @TestVisible
  private final static String OUTPUT_CHARACTERISTIC_VALUE = 'characteristicValue';
  @TestVisible
  private final static String OUTPUT_MRC = 'MRC';
  @TestVisible
  private final static String OUTPUT_NRC = 'NRC';
  @TestVisible
  private final static String OUTPUT_PUBLIC_OFFER_NAME = 'PublicOfferName';
  @TestVisible
  private final static String OUTPUT_COMMERCIAL_DESCRIPTION = 'CommercialDescription';

  public String sourceProductName;
  public String sourceProductCode;
  public String characteristicName;
  public String characteristicValue;
  public String channels;
  public String targetCharacteristicName;
  public String targetCharacteristicValue;
  public String mrc;
  public String nrc;
  public String itemName;
  public String pitchOrder;
  public String publicOfferName;
  public String commercialDescription;
  public String offerVariantCode;
  public Boolean isOrderable = false;

  @TestVisible
  private VNOS_DOMAIN_AttributePricingMatrixRow() {
  }

  public VNOS_DOMAIN_AttributePricingMatrixRow(
    CalculationMatrixRow calculationMatrixRow
  ) {
    if (calculationMatrixRow != null) {
      Map<String, Object> inputData = (Map<String, Object>) JSON.deserializeUntyped(
        calculationMatrixRow.InputData
      );
      Map<String, Object> outputData = (Map<String, Object>) JSON.deserializeUntyped(
        calculationMatrixRow.OutputData
      );
      if (inputData != null && outputData != null) {
        sourceProductName = String.valueOf(
          inputData.get(CONST_SOURCE_PRODUTC_NAME)
        );
        sourceProductCode = String.valueOf(
          inputData.get(CONST_SOURCE_PRODUTC_CODE)
        );
        characteristicName = String.valueOf(
          inputData.get(CONST_CHARACTERISTIC_NAME)
        );
        characteristicValue = String.valueOf(
          inputData.get(CONST_CHARACTERISTIC_VALUE)
        );
        channels = String.valueOf(outputData.get(CONST_CHANNELS));
        targetCharacteristicName = String.valueOf(
          outputData.get(CONST_TARGET_CHARACTERISTIC_NAME)
        );
        targetCharacteristicValue = String.valueOf(
          outputData.get(CONST_TARGET_CHARACTERISTIC_VALUE)
        );
        mrc = String.valueOf(outputData.get(CONST_MRC));
        nrc = String.valueOf(outputData.get(CONST_NRC));
        itemName = String.valueOf(outputData.get(CONST_ITEM_NAME));
        pitchOrder = String.valueOf(outputData.get(CONST_PITCH_ORDER));
        publicOfferName = String.valueOf(
          outputData.get(CONST_PUBLIC_OFFER_NAME)
        );
        commercialDescription = String.valueOf(
          outputData.get(CONST_COMMERCIAL_DESCRIPTION)
        );
        offerVariantCode = String.valueOf(
          outputData.get(CONST_OFFER_VARIANT_CODE)
        );
        this.orderable(outputData.get(CONST_ORDERABLE));
      }
    }
  }

  public Integer getOrderForGroup() {
    Integer orderForGroup = 0;
    if (String.isNotBlank(pitchOrder)) {
      List<String> pitchOrderHieararchy = pitchOrder.split('-');
      if (pitchOrderHieararchy.size() >= 1) {
        try {
          orderForGroup = Integer.valueOf(pitchOrderHieararchy.get(0));
        } catch (Exception numberFormatException) {
          System.debug(
            'at getOrderForGroup :' +
              pitchOrderHieararchy.get(0) +
              ' is not a valid number'
          );
        }
      }
    }
    return orderForGroup;
  }

  public Integer getOrderInGroup() {
    Integer orderInGroup = 0;
    if (String.isNotBlank(pitchOrder)) {
      List<String> pitchOrderHieararchy = pitchOrder.split('-');
      if (pitchOrderHieararchy.size() >= 2) {
        try {
          orderInGroup = Integer.valueOf(pitchOrderHieararchy.get(1));
        } catch (Exception numberFormatException) {
          System.debug(
            'at getOrderForGroup :' +
              pitchOrderHieararchy.get(1) +
              ' is not a valid number'
          );
        }
      }
    }
    return orderInGroup;
  }

  public Boolean isEligibleForChannel(String channel) {
    return String.isNotBlank(this.channels) && this.channels.contains(channel);
  }

  public void orderable(Object value) {
    try {
      String isOrderable = String.valueOf(value);
      this.isOrderable = Boolean.valueOf(isOrderable);
    } catch (Exception e) {
      System.debug(e.getMessage());
      System.debug(e.getStackTraceString());
      this.isOrderable = false;
    }
  }

  public Map<String, Object> toResponse() {
    Map<String, Object> response = new Map<String, Object>();
    response.put(OUTPUT_SOURCE_PRODUCT_CODE, sourceProductCode);
    response.put(OUTPUT_CHARACTERISTIC_NAME, characteristicName);
    response.put(OUTPUT_CHARACTERISTIC_VALUE, characteristicValue);
    response.put(OUTPUT_MRC, mrc);
    response.put(OUTPUT_NRC, nrc);
    response.put(OUTPUT_PUBLIC_OFFER_NAME, publicOfferName);
    response.put(OUTPUT_COMMERCIAL_DESCRIPTION, commercialDescription);

    return response;
  }
}
