/** first find customers with at least one funded savings plan with
   the assumption that plans with amount > 0 is considered funded
**/
with funded_savings_plan as (
select s.owner_id
      ,count(*) as savings_count
      ,sum(p.amount/100) as total_savings  -- division by 100 to convert to naira
from adashi_staging.savings_savingsaccount s
join adashi_staging.plans_plan p on p.id = s.plan_id
where p.is_regular_savings = '1'
 and p.amount > '0'
group by s.owner_id
),
/** second, find customers with ONE funded investment plan with 
    the assumption that plans with amount > 0 is considered funded
**/
funded_investment_plan as (
select s.owner_id
      ,count(*) as investment_count
      ,sum(p.amount/100) as total_investment  -- division by 100 to convert to naira
from adashi_staging.savings_savingsaccount s
join adashi_staging.plans_plan p on p.id = s.plan_id
where p.is_a_fund = '1' 
and p.amount > '0'
group by s.owner_id
having count(*) = 1
)
/** finally, combine these 2 tables to confirm customers with both
   funded savings and investment plans
**/

select  sp.owner_id
       ,concat(u.first_name,' ',u.last_name) as name
	   ,sp.savings_count
       ,ip.investment_count
       ,(sp.total_savings + ip.total_investment) as total_deposits
from funded_savings_plan sp
join funded_investment_plan ip on sp.owner_id = ip.owner_id
join adashi_staging.users_customuser as u on sp.owner_id = u.id
order by total_deposits desc
