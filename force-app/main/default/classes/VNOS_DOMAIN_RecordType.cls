public class VNOS_DOMAIN_RecordType {
  private static final String CONST_DEVELOPER_NAME = 'DeveloperName';
  private static final String CONST_ID = 'Id';

  public Map<String, Object> node = new Map<String, Object>();

  public VNOS_DOMAIN_RecordType() {
  }

  public VNOS_DOMAIN_RecordType(Object recordTypeNode) {
    if (
      recordTypeNode != null && recordTypeNode instanceof Map<String, Object>
    ) {
      node = (Map<String, Object>) recordTypeNode;
    }
  }

  public String developerName() {
    return String.ValueOf(node.get(CONST_DEVELOPER_NAME));
  }
  public String id() {
    return String.ValueOf(node.get('Id'));
  }
}