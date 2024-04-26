/*
2.  Does educational qualification correlate with the feedback given? 
*/

select                                                                      Educational_Qualifications
                                                                            ,Feedback
            ,count(Feedback)                                                'Count'
            ,concat(round(( cast( count(Feedback) 
                            as float) 
                            / 
                            cast((  select count(*)
                                    from    online_food_orders ofox
                                    where   ofox.Educational_Qualifications
                                        = ofo.Educational_Qualifications)
                            as float)
                            *
                            100)
                    , 2), ' %')
                                                                            '% of Orders in Education Level'
from        online_food_orders ofo
group by    Educational_Qualifications, Feedback
order by    1 desc, 2 desc;