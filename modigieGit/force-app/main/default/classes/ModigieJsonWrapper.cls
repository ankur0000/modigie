public class ModigieJsonWrapper {
    public class creditListWrapper{
        public itemsWrapper[] items;
        public Integer pageSize;	//10
        public String pageToken;
        public String updateTime;
    }
    public class itemsWrapper {
        public balanceWrapper balance;
        public contractWrapper contract;
        public String createTime;	//2021-04-05T04:02:31Z
        public Integer creditsLeft;	//0
        public Integer creditsLimit;	//0
        public Integer creditsReserved;	//0
        public Integer creditsTotal;	//0
        public currencyWrapper currency_x;
        public customerWrapper customer;
        public String customerRef;
        public Integer discount;	//0
        public String id;
        public minBalanceLimitWrapper minBalanceLimit;
        public String name;
        public quotaWrapper quota;
        public String status;	//active
        public String title;	//Default credits account
        public String updateTime;
    }
    public class balanceWrapper {
        public String amount;	//0.0000
        public currencyWrapper currency_x;
    }
    public class currencyWrapper {
        public String code;
    }
    public class contractWrapper {
        public String contractType;
        public String id;
        public String name;
    }
    public class customerWrapper {
        public String id;
        public String name;
    }
    public class minBalanceLimitWrapper {
        public String amount;	//0.0000
        public currencyWrapper currency_x;
    }
    public class quotaWrapper {
        public string stopUntilTime;
        public reasonWrapper stopReason;
    }
    public class reasonWrapper {
		public String body;	//Insufficient funding in credit account with ID <code>R9gDxJC5JiYQutzy4CIz</code>. Please make a payment or contact Modigie support.
		public Integer code;	//402
		public String id;	//InsufficientCreditsError
		public String level;	//error
		public String message;	//Payment Required: Insufficient funding in credit account with ID <code>R9gDxJC5JiYQutzy4CIz</code>. Please make a payment or contact Modigie support.
		public String subtitle;	//Error
		public String title;	//Payment Required
	}
    
    public class ModigieCredentials{
        public cls_apiKey apiKey;
        public cls_serviceAccount serviceAccount;
        public String updateTime;
    }
    public class cls_apiKey {
		public String keyString;
	}
	public class cls_serviceAccount {
		public String clientEmail;
		public String privateKey;
	}

    public class repositoryWrapper{
        public String createTime;
        public Customer customer;
        public FeatureConfig featureConfig;
        public String id;
        public Boolean isProduction;
        public String name;
        public String status;
        public String subject;
        public Quota quota;
        public String updateTime;
    }

    public class Tom {
		public String fromTime;
		public String untilTime;
	}

	public class Rulesets {
		public String unlockUntilTime;
		public UnlockReason unlockReason;
	}

	public class Quota {
		public String stopUntilTime;
		public UnlockReason stopReason;
	}

	public class Customer {
		public String id;
		public String name;
	}

	public class FeatureConfig {
		public Tom tom;
		public Performance performance;
	}

	public class UnlockReason {
		public Integer code;
		public String message;
	}

	public class Performance {
		public Rulesets rulesets;
	}


    public class personSyncWrapper{
        public cls_client client = new cls_client();
        public cls_items[] items = new List<cls_items>();
        public cls_rulesets[] rulesets = new List<cls_rulesets>();
    }
	public class cls_client {
		public String code;	//sfdc
		public String version;	//1.70.0
	}
	public class cls_items {
		public String id;	//00Q1U00000X3nidUAB
		public String objectType;	//Contact
		public String firstName;	//Ken
		public String lastName;	//Hoppe
		public cls_company company = new cls_company();
		public cls_emailAddresses[] emailAddresses = new List<cls_emailAddresses>();
		public cls_phoneNumbers[] phoneNumbers = new List<cls_phoneNumbers>();
		public cls_urls[] urls = new List<cls_urls>();
		public cls_syncTrigger syncTrigger = new cls_syncTrigger();
		public cls_progress progress = new cls_progress();
	}
	public class cls_company {
		public String title;	//Google
		public String accountId;	//00R1K00000F3opgMVI
	}
	public class cls_emailAddresses {
		public cls_emailAddress emailAddress = new cls_emailAddress();
		public List<String> rels = new List<String>();
		public String origin;	//salesforce-email
	}
	public class cls_emailAddress {
		public String userFormat;	//hoppe@google.com
	}
	public class cls_phoneNumbers {
		public cls_phoneNumber phoneNumber = new cls_phoneNumber();
		public List<String> rels = new List<String>();
		public String origin;	//salesforce-phone
	}
	public class cls_phoneNumber {
		public String userFormat;	//(234) 567-8901
	}
	public class cls_urls {
		public cls_url url = new cls_url();
		public List<String> rels = new List<String>();
		public String origin;	//salesforce-url
	}
	public class cls_url {
		public String userFormat;	//linkedin.com/in/kenhoppe
	}
	public class cls_syncTrigger {
		public cls_creditAccount creditAccount = new cls_creditAccount();
		public cls_ruleset ruleset = new cls_ruleset();
		public cls_triggerType triggerType = new cls_triggerType();
	}
	public class cls_creditAccount {
		public String id;	//elwkefOe49sDK
	}
	public class cls_ruleset {
		public String id;	//D001JIhgs0YUCX
	}
	public class cls_triggerType {
		public String automation;	//L001000las0POZA
	}
	public class cls_progress {
		public cls_job job = new cls_job();
	}
	public class cls_job {
		public String jobType;	//mobilePhone
	}
	public class cls_rulesets {
		public String id;	//D001JIhgs0YUCX
		public String title;	//Example ruleset
		public String objectType;	//Contact
		public String logic;	//foo > 1 and bar == true
	}
}