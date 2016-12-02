SELECT o.ADVERTISER_ID, o.advertiser_name, o.account_manager_name, sf_acc.LEGAL_ENTITY__C as LEGAL_ENTITY, o.DISCOUNT, 
sf_acc.name as sf_account_name, sf_acc.id as sf_account_id, sf_acc.payment_method__c, sf_acc.payment_method_oracle__c, sf_acc.payment_terms__c, round(sum(fyber_gross_revenue_eur),0) as last_month_rev_eur
FROM datamart.advertiser_perspective_daily AS od
INNER JOIN datamart.DIM_OFFER AS o ON o.ID = od.OFFER_ID
LEFT JOIN dwh.SALESFORCE_BACKEND AS sf_bac ON sf_bac."Product ID" = CAST(o.ADVERTISER_ID AS VARCHAR(30)) AND sf_bac.DELETED = false AND sf_bac."Product Type" = 'Advertiser'
LEFT JOIN dwh.SALESFORCE_ACCOUNT AS sf_acc ON sf_acc.id = sf_bac.account
WHERE o.TEST_OFFER = 'NOT_TEST_OFFER' and advertiser_id not in (60536,59398) --FyberRTB accounts
and fact_day >= date_trunc('month',curdate()-1)
group by 1,2,3,4,5,6,7,8,9,10
having sum(fyber_gross_revenue_eur) > 10 and sf_acc.id is null
ORDER BY 11, 3