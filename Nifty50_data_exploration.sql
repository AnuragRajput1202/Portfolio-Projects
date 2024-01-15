select * from nifty50 order by trading_date,symbol

--displays all nifty50 companies data from year 2019,2020 and 2021

select distinct symbol as companies from nifty50

--displays all the nifty50 companies

select symbol, prev_close, close, 
round(((close-prev_close)/prev_close)*100,2) "1D-Gain/Loss%"
from nifty50

--one day returns%

select symbol, floor(avg(volume)) daily_avg_volume from nifty50
group by symbol order by 2 DESC

--daily average volume trades from 2019 to 2021

select symbol, max(high) highest_in_2020 from nifty50 
where trading_date between '01-01-20' and '31-12-20'
group by symbol
 
--Yearly highs in the year 2020

select symbol, sum(volume) most_traded_in_2019 from nifty50
where trading_date between '01-01-19' and '31-12-19'
group by symbol
order by sum(volume) desc

--most traded shares in the year 2019 by volume

select symbol, round(avg(low),2) as three_year_average from nifty50
group by symbol order by 2 desc

--3 year(2019 to 2021) average price for each listed company


select symbol, to_char(trading_date,'YYYY-MM') as Month, 
round(avg(close),2) as average_closing_price from nifty50
where symbol=upper('&enter')
group by symbol, to_char(trading_date,'YYYY-MM')
order by month

--average monthly close price

select symbol, min(low) "52_week_low", max(high) "52_week_high"
from nifty50 
where trading_date>=(select (max(trading_date)-52*7) from nifty50)
group by symbol order by symbol


--52 week high and low as of date ='30-04-21'

select symbol, trading_date, round(((close-prev_close)/prev_close)*100,2) 
as one_day_return from nifty50
where round(((close-prev_close)/prev_close)*100,2)=(select max(round(((close-prev_close)/prev_close)*100,2))
from nifty50 where symbol='INDUSINDBK')
and symbol='INDUSINDBK'
order by trading_date

--day when maximum one day return was achieved by any stock


select symbol, trading_date, volume
from nifty50
where volume > (select avg(volume) * 2 from nifty50 where symbol='TATAMOTORS')
and symbol='TATAMOTORS'
ORDER BY trading_date;

--dates when abnormal volume(more than twice the average volume) in trades were observed in any stock


select symbol, trading_date, open, high, close,
       avg(close) over (partition BY symbol order by trading_date
       rows between 1 preceding and current row) AS moving_average
FROM nifty50
WHERE symbol = upper('&enter')
ORDER BY trading_date

--2 days moving average for any stock

select * FROM
(select x.symbol, x.trading_date, x.open, x.high, x.close, 
case when row_number() over (order by trading_date) > 9
     then sum(close) over (order by trading_date rows between 9 preceding and current row) / 10
     end "10_day_MAV",
case when row_number() over (order by trading_date) > 49
     then sum(close) over (order by trading_date rows between 49 PRECEDING AND CURRENT ROW) / 50
     end "50_day_MAV"
from nifty50 x where symbol = upper('&ENTER')
) order by trading_date; 

--10 days and 50 days moving average for any stock


select * from
(select symbol, trading_date, close, prev_close, close/lag(close)
over (partition by symbol order by trading_date) as Price_ratio
from nifty50
order by trading_date)
where price_ratio<0.7

--finding stock splits


select a.symbol symbol_a, a.trading_date, a.close close_price_a,
b.symbol symbol_b, b.close close_price_b
from nifty50 a join nifty50 b
on a.trading_date=b.trading_date
where a.symbol='HCLTECH' and b.symbol='INFY'
order by a.trading_date

--comparing close price of two stocks

select a.symbol symbol_a, a.trading_date, 
round(((a.close-a.prev_close)/a.prev_close)*100,2) "%1D-Return_A",
b.symbol symbol_b, round(((b.close-b.prev_close)/b.prev_close)*100,2) "%1D-Return_B"
from nifty50 a join nifty50 b
on a.trading_date=b.trading_date
where a.symbol='HDFCBANK' and b.symbol='AXISBANK'
order by a.trading_date

--comparing one day returns of two stocks

select * from nifty50

