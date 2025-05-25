use polars::prelude::*;

mod model;
use fake::{Fake, Faker};

fn account_df(n: usize) -> DataFrame {
    let rows = (0..n)
        .map(|_| Faker.fake::<model::Account>())
        .collect::<Vec<model::Account>>();

    DataFrame::new(vec![
        Column::new(
            "account_id".into(),
            rows.iter()
                .map(|x| x.account_id.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "name".into(),
            rows.iter()
                .map(|x| x.name.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "age".into(),
            rows.iter().map(|x| x.age as u32).collect::<Vec<u32>>(),
        ),
        Column::new(
            "phone_number".into(),
            rows.iter()
                .map(|x| x.phone_number.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "company".into(),
            rows.iter()
                .map(|x| x.company.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "email".into(),
            rows.iter()
                .map(|x| x.email.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "address".into(),
            rows.iter()
                .map(|x| x.address.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "registered_at".into(),
            rows.iter()
                .map(|x| x.registered_at.naive_utc())
                .collect::<Vec<chrono::NaiveDateTime>>(),
        ),
        Column::new(
            "memo".into(),
            rows.iter()
                .map(|x| x.memo.to_owned())
                .collect::<Vec<String>>(),
        ),
    ])
    .unwrap()
}

fn calendar_df(from: &chrono::NaiveDate, to: &chrono::NaiveDate) -> DataFrame {
    let mut dates = Vec::new();

    let mut dt = from.to_owned();
    while dt <= *to {
        dates.push(dt);
        dt = dt.succ_opt().unwrap();
    }

    let df = DataFrame::new(vec![Column::new("date".into(), dates)]).unwrap();
    df.lazy()
        .with_columns(vec![
            col("date").dt().year().alias("year"),
            col("date").dt().month().alias("month"),
            col("date").dt().day().alias("day"),
        ])
        .collect()
        .unwrap()
}

pub struct AccountIds<'a> {
    ids: &'a polars::series::Series,
}

impl<'a> fake::Dummy<AccountIds<'a>> for String {
    fn dummy_with_rng<R: fake::rand::Rng + ?Sized>(
        account_ids: &AccountIds<'a>,
        rng: &mut R,
    ) -> Self {
        let n = account_ids.ids.len();
        let idx = rng.random_range(0..n);
        account_ids.ids.get(idx).unwrap().str_value().to_string()
    }
}

impl<'a> AccountIds<'a> {
    pub fn new(ids: &'a polars::series::Series) -> Self {
        Self { ids }
    }
}

fn purchase_df(n: usize, accounts: &DataFrame) -> DataFrame {
    let account_ids = AccountIds::new(accounts.column("account_id").unwrap().as_series().unwrap());

    let purchased_by = Column::new(
        "purchased_by".into(),
        (0..n).map(|_| account_ids.fake()).collect::<Vec<String>>(),
    );
    let rows = (0..n)
        .map(|_| Faker.fake::<model::Purchase>())
        .collect::<Vec<model::Purchase>>();

    DataFrame::new(vec![
        Column::new(
            "purchase_id".into(),
            rows.iter()
                .map(|x| x.purchase_id.to_owned())
                .collect::<Vec<String>>(),
        ),
        Column::new(
            "purchased_at".into(),
            rows.iter()
                .map(|x| x.purchased_at.naive_utc())
                .collect::<Vec<chrono::NaiveDateTime>>(),
        ),
        purchased_by,
        Column::new(
            "item".into(),
            rows.iter().map(|x| x.item.name.to_owned()).collect::<Vec<String>>(),
        ),
        Column::new(
            "amount".into(),
            rows.iter().map(|x| x.amount as u32).collect::<Vec<u32>>(),
        ),
        Column::new(
            "memo".into(),
            rows.iter().map(|x| x.memo.to_owned()).collect::<Vec<String>>(),
        )
    ])
    .unwrap()
}

fn main() {
    let accounts = account_df(5);
    println!(
        "accounts: estimated memory size {} MB",
        accounts.estimated_size() / 1024 / 1024
    );
    println!("accounts: {}", accounts);

    let purchases = purchase_df(100, &accounts);
    println!(
        "purchases: estimated memory size {} MB",
        purchases.estimated_size() / 1024 / 1024
    );
    println!("purchases: {}", purchases);

    // let calendar = calendar_df(
    //     &chrono::NaiveDate::from_ymd_opt(2024, 10, 1).unwrap(),
    //     &chrono::NaiveDate::from_ymd_opt(2025, 5, 12).unwrap(),
    // );

    // println!("estimated memory size {} MB", calendar.estimated_size() / 1024 / 1024);
    // println!("{}", calendar);
}
