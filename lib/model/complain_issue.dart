class MainIssue{
   String code;
   String description;
  MainIssue();
  MainIssue.fromJson(Map<String,dynamic> json){
    code=json['MAINCODE'];
    description=json['MAIN_ISSUEDESCR'];}
    @override
  String toString() {
    return description;
  }
}
class SubIssue{
   String mainissuecode;
   String subissuecode;
   String description;
   SubIssue();
   SubIssue.fromJson(Map<String,dynamic> json){
     mainissuecode=json['MAINCODE'];
     subissuecode=json['SUBCODE'];
    description=json['SUB_ISSUEDESCR'];}
    @override
  String toString() {
    return description;
  }
}
