figure(1)
histogram2(s1(:,1),s1(:,2),'Normalization','pdf');
xlabel('x');ylabel('y');zlabel('f1(x)');
title('Empirical pdf');
figure(2)
histogram2(s2(:,1),s2(:,2),'Normalization','pdf');
xlabel('x');ylabel('y');
title('Empirical pdf');zlabel('f2(x)');