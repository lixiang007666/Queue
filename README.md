# Queue
排队论模拟
@[toc]
# 1 概述
生活中需要排队的地方很多，本模型用于分析和仿真现实生活中的排队现象。
排队论发源于上世纪初。当时美国贝尔电话公司发明了自动电话，以适应日益繁忙的工商业电话通讯需要。这个新发明带来了一个新问题，即通话线路与电话用户呼叫的数量关系应如何妥善解决，这个问题久久未能解决。
1909年，丹麦的哥本哈根电话公司A.K.埃尔浪(Erlang)在热力学统计平衡概念的启发下解决了这个问题。1917 年，爱尔朗发表了他的著名的文章—“自动电话交换中的概率理 论的几个问题的解决”。排队论已广泛应用于解决军事、运输、维修、生产、服务、库 存、医疗卫生、教育、水利灌溉之类的排队系统的问题，显示了强大的生命力。
# 2 模型介绍
（1）由于顾客到达和服务时间的随机性，
现实中的排队现象几乎不可避免；
（2）排队过程，通常是一个随机过程，
排队论又称“随机服务系统理论”；
## 2.1 排队服务过程
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200527212035422.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzgzODc4NQ==,size_16,color_FFFFFF,t_70)
## 2.2 排队系统的要素

（1）顾客输入过程；
（2）排队结构与排队规则；
（3）服务机构与服务规则；
## 2.3  顾客输入过程
顾客源(总体)：有限/无限;
顾客到达方式：逐个/逐批;(仅研究逐个情形)
顾客到达间隔：随机型/确定型;
顾客前后到达是否独立：相互独立/相互关联；
输入过程是否平稳：平稳/非平稳；(仅研究平稳性)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200527212143199.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzgzODc4NQ==,size_16,color_FFFFFF,t_70)
## 2.4 排队结构与排队规则
顾客排队方式：等待制/即时制(损失制);
排队系统容量：有限制/无限制;
排队队列数目: 单列/多列;
是否中途退出: 允许/禁止;
是否列间转移: 允许/禁止;
(仅研究禁止退出和转移的情形)
## 2.5 服务机构与服务规则
服务台(员)数目;单个/多个;
服务台(员)排列形式;并列/串列/混合;
服务台(员)服务方式;逐个/逐批;(研究逐个情形)
服务时间分布;随机型/确定型;
服务时间分布是否平稳:平稳/非平稳;(研究平稳情形)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200527212234556.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzgzODc4NQ==,size_16,color_FFFFFF,t_70)

# 3 代码实现
设顾客到达速率服从参数为lambda的负指数分布，服务速率为mu的负指数分布，服务强度rho = lambda / mu

则当lambda <= mu时，则rho <= 1，队伍的长度L会逐渐增长并收敛至L = lambda/(mu - lambda)，平均等待时间会收敛至W = 1 / (mu - lambda)

反之若lambda > mu，rho > 1，L和W会随着到达的顾客数的增加而增加，不会收敛。

采用MATLAB生成服从负指数分布的随机数，并对队长以及等待时间进行统计，最后画图展示出排队的过程

eg:
lambda = 0.1493
mu = 0.1587

模拟结果如下
**PCU也称当量交通量。**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200527213118684.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzgzODc4NQ==,size_16,color_FFFFFF,t_70)

```python

ave_t = zeros(10,100);
p = zeros(10,100);
nn = 10:10:5000;    %到达路口的车数
count = zeros(size(nn,2),100);    %队列长度

for d = 1:length(nn)
    for s = 1:100 
        n = nn(d);    %模拟车辆数目
        dt = exprnd(6.7,1,n);    %模拟到达时间间隔
        st = exprnd(6.3,1,n);    %每辆车经过路口所用的时间
        a = zeros(1,n);    %每辆车到达时刻
        b = zeros(1,n);    %每辆车到达路口的时刻
        c = zeros(1,n);    %每辆车离开时刻
        a(1) = 0;
        
        for i = 2:n
            a(i) = a(i-1) + dt(i-1);
        end
        
        b(1) = 0;
        c(1) = b(1) + st(1);
        
        for i = 2:n
%如果第i辆车到达路口比前一辆离开的时间早，则其到达路口停车线的时间为前一辆车离开时间
           if(a(i) <= c(i-1))
               b(i) = c(i-1);
%如果第i辆车到达路口比前一辆离开的时间晚，则其到达路口停车线的时间为其到达时间
           else
               b(i) = a(i);
           end
%第i辆车离开时间为其到达路口停车线的时刻+通过路口需要的时间
           c(i) = b(i) + st(i);
       end
           
       for i = 2:n
           if(a(i) <= c(i-1))
               count(d,s) = count(d,s) + 1;
           else
               break;
           end
       end
           
        cost = zeros(1,n);
        for i = 1:n
            cost(i)=c(i)-a(i);    %第i辆车在队列中等待的时间
        end
        T = c(n);    %总时间
        p(d,s) = sum(st)/T;
        ave_t(d,s) = sum(cost)/n;
    end
end
pc = sum(p,2)/100;    %服务强度
aver_tc = sum(ave_t,2) / 100;    %在队列中耗费的平均时间
count = sum(count,2) / 100;

%画图部分
figure;
subplot(2,1,1)
plot(nn,aver_tc);
grid on;
title('平均等待时间随到达路口车辆总数变化曲线  单位：秒')
xlabel('到达路口车辆总数')
ylabel('平均等待时间')   

subplot(2,1,2)
plot(nn,count);
grid on;
%ylim([0,2])
title('队列中的交通量数随到达路口车辆总数变化曲线  单位：pcu')
xlabel('到达路口车辆总数')
ylabel('队列中的车辆数') 
set(gcf,'color','w');
%p = fig2plotly(gcf,'offline',true);  

```
