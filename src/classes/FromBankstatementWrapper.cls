// This class is used Parse Jason Resonse for Bank Statement
public class FromBankstatementWrapper{
    public cls_BankName bankname;
    public class cls_BankName {
        public cls_accounts[] accounts;
    }
    public class cls_accounts{
        public String accountHolder;    //Mary Jones
        public String name; //Transaction Account
        public String accountNumber;    //456789
        public String id;   //456789
        public String bsb;  //123-456
        public String balance;  //123.45
        public String available;    //123.45
        public cls_statementData statementData;
        public String institution;  //Bank of Statements
    }
    public class cls_statementData {
        public cls_details[] details;
        public String totalCredits; //20045.07
        public String totalDebits;  //-16260.41
        public String openingBalance;   //-3661.21
        public String closingBalance;   //123.45
        public String startDate;    //03-07-2015
        public String endDate;  //22-01-2016
        public String minBalance;   //-3661.21
        public String maxBalance;   //1603.32
        public cls_dayEndBalances[] dayEndBalances;
        public String minDayEndBalance; //-3518.36
        public Double daysInNegative;  //80
        public String errorMessage; //
        public cls_analysis analysis;
    }
   public class cls_details {
        public cls_strDateObj strDateObj;
        public String strDate; //06-07-2015
        public String text; //Dishonoured Payment - SLS
        public string notes;
        public Double amount;   //68.6
        public String type; //Credit
        public String balance;  //-3449.76
 //       public cls_tags[] tags;
    }
    public class cls_strDateObj {
        public String strDate; //2015-12-26 10:36:15.000000
        public Double timezone_type;   //3
        public String timezone; //Australia/Sydney
    }
//    public class cls_notes {
//    }
    public class cls_tags {
        public String Income;    //O
        public String Dishonours;    //t
        public String Benefits;    //h
        public String strLoans;    //e
        public String strShortTermLender;    //r
        public String strRent;    // 
        public String strOtherDebits;    //D      
    }
   public class cls_dayEndBalances {
        public String strDate; //2016-01-22
        public String balance;  //123.45
    }
    public class cls_analysis {
        public cls_Income Income;
        public cls_Benefits Benefits;
        public cls_Dishonours Dishonours;
        public cls_Loans Loans;
        public cls_Rent Rent;
        public cls_Gambling Gambling;
        public cls_OtherDebits OtherDebits;
    }
    public class cls_Income {
        public cls_total total;
        public cls_Wages Wages;
        public cls_Rent Rent;
        public cls_Interest Interest;
    }
    public class cls_total {
        public Double transactionCount;    //10
        public Double totalValue;   //2912.25
        public Double monthAvg; //416.03571428571
    }
    public class cls_Wages {
        public Double transactionCount;    //14
        public Double totalValue;   //3106.53
        public Double monthAvg; //443.79
        public String minValue; //12.79
        public String maxValue; //409.08
        public String firstTransaction; //07-01-2016
        public String lastTransaction;  //28-07-2015
        public Double period;  //12
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_transactions {
        public cls_strDateObj strDateObj;
        public String strDate; //06-07-2015
        public String text; //Dishonoured Payment - SLS
        public string notes;
        public Double amount;   //68.6
        public String type; //Credit
        public String balance;  //-3449.76
  //      public cls_tags[] tags;
    }
    public class cls_Rent {
        public cls_Rent Rent;
        public Double transactionCount;    //18
        public Double totalValue;   //4318.72
        public Double monthAvg; //616.96
        public String minValue; //9.47
        public String maxValue; //459.52
        public String firstTransaction; //23-12-2015
        public String lastTransaction;  //24-07-2015
        public Double period;   //8.5
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_firstTransaction {
    }
    public class cls_lastTransaction {
    }
    public class cls_Interest {
        public Double transactionCount;    //1
        public Double totalValue;   //2.45
        public Double monthAvg; //0.35
        public String minValue; //2.45
        public String maxValue; //2.45
        public String firstTransaction; //22-01-2016
        public String lastTransaction;  //22-01-2016
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Benefits {
        public cls_total total;
        public cls_MaternityPayment MaternityPayment;
        public cls_FamilyBenefits FamilyBenefits;
        public cls_SchoolkidsBonus SchoolkidsBonus;
        public cls_ParentingPayment ParentingPayment;
        public cls_CarersBenefits CarersBenefits;
        public cls_YouthAllowance YouthAllowance;
        public cls_Newstart Newstart;
        public cls_Pension Pension;
        public cls_AusStudy AusStudy;
        public cls_Medicare Medicare;
        public cls_Other Other;
    }
    public class cls_MaternityPayment {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_FamilyBenefits {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SchoolkidsBonus {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ParentingPayment {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CarersBenefits {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_YouthAllowance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Newstart {
        public Double transactionCount;    //17
        public Double totalValue;   //3078.63
        public Double monthAvg; //439.80428571429
        public String minValue; //14.36
        public String maxValue; //472.45
        public String firstTransaction; //20-01-2016
        public String lastTransaction;  //03-07-2015
        public Double period;   //13.235294117647
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Pension {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_AusStudy {
        public Double transactionCount;    //15
        public Double totalValue;   //4178.95
        public Double monthAvg; //596.99285714286
        public String minValue; //25.75
        public String maxValue; //495.40
        public String firstTransaction; //04-01-2016
        public String lastTransaction;  //22-07-2015
        public Double period;   //12.466666666667
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Medicare {
        public Double transactionCount;    //17
        public Double totalValue;   //5201.02
        public Double monthAvg; //743.00285714286
        public String minValue; //49.67
        public String maxValue; //497.95
        public String firstTransaction; //11-01-2016
        public String lastTransaction;  //06-07-2015
        public Double period;   //11.705882352941
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Other {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Dishonours {
        public cls_total total;
        public cls_Overdrawn Overdrawn;
        public cls_Dishonour Dishonour;
        public cls_Return Returns;
        public cls_Reversal Reversal;
    }
    public class cls_Overdrawn {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Dishonour {
        public Double transactionCount;    //19
        public Double totalValue;   //1303.4
        public Double monthAvg; //186.2
        public String minValue; //68.60
        public String maxValue; //68.60
        public String firstTransaction; //19-01-2016
        public String lastTransaction;  //06-07-2015
        public Double period;   //10.631578947368
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Return {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Reversal {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Loans {
        public cls_total total;
        public cls_AmazingLoans AmazingLoans;
        public cls_AMXMoney AMXMoney;
        public cls_AusFinancial AusFinancial;
        public cls_Aussie Aussie;
        public cls_AussieCash AussieCash;
        public cls_Baycorp Baycorp;
        public cls_CannonFinance CannonFinance;
        public cls_CashAdvance CashAdvance;
        public cls_CashConverters CashConverters;
        public cls_CashDoctors CashDoctors;
        public cls_CashFirst CashFirst;
        public cls_CashinaFlash CashinaFlash;
        public cls_CashMoney CashMoney;
        public cls_CashNow CashNow;
        public cls_CashOz CashOz;
        public cls_CashSolutions CashSolutions;
        public cls_CashSmart CashSmart;
        public cls_CashStop CashStop;
        public cls_CashToday CashToday;
        public cls_CashTrain CashTrain;
        public cls_CenterOne CenterOne;
        public cls_ChampionLoans ChampionLoans;
        public cls_ChampionMoney ChampionMoney;
        public cls_CityFinance CityFinance;
        public cls_ClearCash ClearCash;
        public cls_Credit24 Credit24;
        public cls_CreditCorp CreditCorp;
        public cls_DebtFix DebtFix;
        public cls_DollarsDirect DollarsDirect;
        public cls_EasyFinancing EasyFinancing;
        public cls_FairGoFinance FairGoFinance;
        public cls_Ferratum Ferratum;
        public cls_FirstStopMoney FirstStopMoney;
        public cls_FoxSymes FoxSymes;
        public cls_FundCo FundCo;
        public cls_JacarandaFinance JacarandaFinance;
        public cls_JetLending JetLending;
        public cls_JPCreditline JPCreditline;
        public cls_K24 K24;
        public cls_KangarooPayday KangarooPayday;
        public cls_Kreditech Kreditech;
        public cls_KwikFinance KwikFinance;
        public cls_LionFinance LionFinance;
        public cls_LoansbyPhone LoansbyPhone;
        public cls_LoanRanger LoanRanger;
        public cls_MaxFinance MaxFinance;
        public cls_MaxFunding MaxFunding;
        public cls_MoneyCentre MoneyCentre;
        public cls_MoneyMe MoneyMe;
        public cls_MoneyNow MoneyNow;
        public cls_MoneyPlus MoneyPlus;
        public cls_Money3 Money3;
        public cls_MoneyStart MoneyStart;
        public cls_MorganFinance MorganFinance;
        public cls_MyBudget MyBudget;
        public cls_NeedyMoney NeedyMoney;
        public cls_Nimble Nimble;
        public cls_OKMoney OKMoney;
        public cls_PaydayKing PaydayKing;
        public cls_PaydayLand PaydayLand;
        public cls_PaydayMate PaydayMate;
        public cls_Payday247 Payday247;
        public cls_PerfectPayday PerfectPayday;
        public cls_PersonalFinanceCo PersonalFinanceCo;
        public cls_PrimeLenders PrimeLenders;
        public cls_RapidLoans RapidLoans;
        public cls_SecureFunding SecureFunding;
        public cls_SpeedyFinance SpeedyFinance;
        public cls_SpeedyMoney SpeedyMoney;
        public cls_SpotLoans SpotLoans;
        public cls_SRGFinance SRGFinance;
        public cls_StressLess StressLess;
        public cls_SunshineLoans SunshineLoans;
        public cls_SwooshFinance SwooshFinance;
        public cls_TeleLoans TeleLoans;
        public cls_Thorn Thorn;
        public cls_VictoryFunding VictoryFunding;
        public cls_WebMoneyline WebMoneyline;
        public cls_YesLoans YesLoans;
        public cls_CollectionHouse CollectionHouse;
        public cls_ToyotaFinance ToyotaFinance;
        public cls_ImpactFinancial ImpactFinancial;
        public cls_YamahaMotorFinance YamahaMotorFinance;
        public cls_HomeLoan HomeLoan;
        public cls_Generic Generic;
    }
    public class cls_AmazingLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_AMXMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_AusFinancial {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Aussie {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_AussieCash {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Baycorp {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CannonFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashAdvance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashConverters {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashDoctors {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashFirst {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashinaFlash {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashNow {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashOz {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashSolutions {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashSmart {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashStop {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashToday {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CashTrain {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CenterOne {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ChampionLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ChampionMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CityFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ClearCash {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Credit24 {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CreditCorp {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_DebtFix {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_DollarsDirect {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_EasyFinancing {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_FairGoFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Ferratum {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_FirstStopMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_FoxSymes {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_FundCo {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_JacarandaFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_JetLending {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_JPCreditline {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_K24 {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_KangarooPayday {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Kreditech {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_KwikFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_LionFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_LoansbyPhone {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_LoanRanger {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MaxFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MaxFunding {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MoneyCentre {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MoneyMe {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MoneyNow {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MoneyPlus {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Money3 {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MoneyStart {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MorganFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_MyBudget {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_NeedyMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Nimble {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_OKMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PaydayKing {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PaydayLand {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PaydayMate {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Payday247 {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PerfectPayday {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PersonalFinanceCo {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_PrimeLenders {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_RapidLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SecureFunding {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SpeedyFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SpeedyMoney {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SpotLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SRGFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_StressLess {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SunshineLoans {
        public Double transactionCount;    //6
        public Double totalValue;   //411.6
        public Double monthAvg; //58.8
        public String minValue; //68.60
        public String maxValue; //68.60
        public String firstTransaction; //05-01-2016
        public String lastTransaction;  //19-07-2015
        public Double period;  //36
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SwooshFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_TeleLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Thorn {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_VictoryFunding {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_WebMoneyline {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_YesLoans {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CollectionHouse {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ToyotaFinance {
        public Double transactionCount;    //5
        public Double totalValue;   //1309.09
        public Double monthAvg; //187.01285714286
        public String minValue; //92.87
        public String maxValue; //449.10
        public String firstTransaction; //19-12-2015
        public String lastTransaction;  //04-09-2015
        public Double period;   //24.2
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ImpactFinancial {
        public Double transactionCount;    //5
        public Double totalValue;   //1083.77
        public Double monthAvg; //154.82428571429
        public String minValue; //6.67
        public String maxValue; //401.21
        public String firstTransaction; //15-01-2016
        public String lastTransaction;  //05-09-2015
        public Double period;   //46.4
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_YamahaMotorFinance {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_HomeLoan {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Generic {
        public Double transactionCount;    //7
        public Double totalValue;   //1846.02
        public Double monthAvg; //263.71714285714
        public String minValue; //2.20
        public String maxValue; //474.95
        public String firstTransaction; //19-01-2016
        public String lastTransaction;  //06-08-2015
        public Double period;   //24.142857142857
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Gambling {
        public cls_total total;
        public cls_10Bet Bet10;
        public cls_AusBet AusBet;
        public cls_Bet365 Bet365;
        public cls_BetFair BetFair;
        public cls_BetStar BetStar;
        public cls_Bookmaker Bookmaker;
        public cls_Centrebet Centrebet;
        public cls_ClassicBet ClassicBet;
        public cls_CrownBet CrownBet;
        public cls_DigiMedia DigiMedia;
        public cls_Ladbrokes Ladbrokes;
        public cls_LeoVegas LeoVegas;
        public cls_Luxbet Luxbet;
        public cls_OzBet OzBet;
        public cls_Palmerbet Palmerbet;
        public cls_Punters Punters;
        public cls_Pokerstars Pokerstars;
        public cls_RoxyPalace RoxyPalace;
        public cls_Sportsbet Sportsbet;
        public cls_Sportsbetting Sportsbetting;
        public cls_Sportingbet Sportingbet;
        public cls_TABTouch TABTouch;
        public cls_Tatts Tatts;
        public cls_TomWaterhouse TomWaterhouse;
        public cls_UBET UBET;
        public cls_Unibet Unibet;
        public cls_WilliamHill WilliamHill;
        public cls_Casino Casino;
        public cls_Lottery Lottery;
    }
    public class cls_10Bet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_AusBet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Bet365 {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_BetFair {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_BetStar {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Bookmaker {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Centrebet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_ClassicBet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_CrownBet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_DigiMedia {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Ladbrokes {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_LeoVegas {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Luxbet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_OzBet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Palmerbet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Punters {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Pokerstars {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_RoxyPalace {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Sportsbet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Sportsbetting {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Sportingbet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_TABTouch {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Tatts {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_TomWaterhouse {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_UBET {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Unibet {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_WilliamHill {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Casino {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Lottery {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_OtherDebits {
        public cls_total total;
        public cls_PaygatePayments PaygatePayments;
        public cls_SPER SPER;
        public cls_Certegy Certegy;
    }
    public class cls_PaygatePayments {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_SPER {
        public Double transactionCount;    //10
        public Double totalValue;   //2912.25
        public Double monthAvg; //416.03571428571
        public String minValue; //53.20
        public String maxValue; //471.29
        public String firstTransaction; //27-12-2015
        public String lastTransaction;  //20-07-2015
        public Double period;   //16.5
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public class cls_Certegy {
        public Double transactionCount;    //0
        public Double totalValue;  //0
        public Double monthAvg;    //0
        public Double minValue;    //0
        public Double maxValue;    //0
        public String firstTransaction;
        public String lastTransaction;
        public Double period;  //0
        public boolean periodIsRegular;
        public cls_transactions[] transactions;
    }
    public static FromBankstatementWrapper parse(String json){
         system.debug('Stri0000000*****************'+json);
        return (FromBankstatementWrapper) System.JSON.deserialize(json, FromBankstatementWrapper.class);
    }
}