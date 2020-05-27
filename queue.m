
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
