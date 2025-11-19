extension ToMoney on String{
   String toMoney(){
     RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
     return replaceAllMapped(reg, (Match match)=>'${match[1]},');
   }
}