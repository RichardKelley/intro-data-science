create table if not exists foo (
  id integer primary key,
  alpha char(2),
  beta char(2)
);

insert into foo (id, alpha, beta) values
  (0, 'aa', 'xx'),
  (1, 'bb', 'yy'),
  (2, 'cc', 'zz');

create table if not exists bar (
  id integer primary key,
  alpha char(2),
  gamma char(2)
);

insert into bar (id, alpha, gamma) values
  (0, 'aa', 'ab'),
  (1, 'bb', 'bc'),
  (2, 'cc', 'cd');

select * from foo inner join bar on foo.alpha = bar.alpha;

-- equivalently
select * from foo, bar where foo.alpha = bar.alpha;

create table if not exists foobar (
  foo_id integer,
  bar_id integer
);

insert into foobar (foo_id, bar_id) values
  (0, 2),
  (1, 1),
  (2, 0);

select foo.alpha, bar.gamma from foo, foobar, bar where foo.id = foobar.foo_id and bar.id = foobar.bar_id;
