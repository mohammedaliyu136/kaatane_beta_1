class DaysAndTime {
  String openingTime = '';
  String closingTime = '';
  bool mon = false;
  bool tue = false;
  bool wen = false;
  bool thu = false;
  bool fri = false;
  bool sat = false;
  bool sun = false;

  DaysAndTime();
  setOpeningTime(openingTime){
    this.openingTime=openingTime;
  }
  setClosingTime(closingTime){
    this.closingTime=closingTime;
  }
  getDays(){
    return "${mon?'1':'0'}-${tue?'1':'0'}-${wen?'1':'0'}-${thu?'1':'0'}-${fri?'1':'0'}-${sat?'1':'0'}-${sun?'1':'0'}";
  }
  setDays(days){
    var _days = days.split("-");
    mon = _days[0]=="1"?true:false;
    tue = _days[1]=="1"?true:false;
    wen = _days[2]=="1"?true:false;
    thu = _days[3]=="1"?true:false;
    fri = _days[4]=="1"?true:false;
    sat = _days[5]=="1"?true:false;
    sun = _days[6]=="1"?true:false;
  }
  setDay(dayNum){
    if(dayNum==1){
      this.mon = !this.mon;
    }else if(dayNum==2){
      this.tue = !this.tue;
    }else if(dayNum==3){
      this.wen = !this.wen;
    }else if(dayNum==4){
      this.thu = !this.thu;
    }else if(dayNum==5){
      this.fri = !this.fri;
    }else if(dayNum==6){
      this.sat = !this.sat;
    }else if(dayNum==7){
      this.sun = !this.sun;
    }
  }
}