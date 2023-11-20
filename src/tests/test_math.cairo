use core::option::OptionTrait;
use core::traits::{TryInto, Into, DivRem};
use zklink_starknet_utils::math::{u128_fast_shift, fast_power10, u256_fast_pow2};

#[test]
#[available_gas(20000000000)]
#[should_panic(expected: ('exp too big',))]
fn test_u128_fast_shift() {
    let mut i = 0;
    let max_exp = 16;
    loop {
        if i == max_exp {
            break;
        }
        assert(u128_fast_shift(i).into() == common_pow(2, i * 8), 'invalid result');
        i = i + 1;
    };

    assert(u128_fast_shift(i).into() == common_pow(2, i * 8), 'panic');
}

#[test]
#[available_gas(20000000000)]
#[should_panic(expected: ('invalid exp',))]
fn test_u256_fast_pow2() {
    let mut i = 0;
    let max_exp = 255;
    loop {
        if i > max_exp {
            break;
        }
        assert(u256_fast_pow2(i) == common_pow(2, i), 'invalid result');
        i = i + 1;
    };

    assert(u256_fast_pow2(i) == common_pow(2, i), 'panic');
}

#[test]
#[available_gas(20000000000)]
#[should_panic(expected: ('invalid exp',))]
fn test_fast_power10() {
    let mut i = 0;
    let max_exp = 18;
    loop {
        if i > max_exp {
            break;
        }
        assert(fast_power10(i).into() == common_pow(10, i), 'invalid result');
        i = i + 1;
    };

    assert(fast_power10(i).into() == common_pow(10, i), 'panic');
}

// return base^exp
fn common_pow(base: u256, exp: usize) -> u256 {
    let mut res = 1;
    let mut count = 0;
    loop {
        if count == exp {
            break;
        } else {
            res = base * res;
        }
        count = count + 1;
    };
    res
}

#[test]
fn test_u128_div_rem() {
    let value = 10349_u128;
    let div = 7_u128;
    let (q, r) = DivRem::div_rem(value, div.try_into().unwrap());
    assert(q == 1478, 'invalid result');
    assert(r == 3, 'invalid result');
}
