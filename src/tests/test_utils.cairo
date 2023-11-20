use array::ArrayTrait;
use zklink_starknet_utils::utils::{array_slice, u128_join, u128_split, read_sub_u128, uint_min};
use debug::PrintTrait;


#[test]
#[available_gas(20000000000)]
fn test_u128_array_slice() {
    let mut array = ArrayTrait::<u128>::new();
    array.append(1);
    array.append(2);
    array.append(3);

    let res = array_slice(@array, 0, 2);
    assert(res.len() == 2, 'invalid length 1');
    assert(*res[0] == 1, 'invalid value 1');
    assert(*res[1] == 2, 'invalid value 2');

    let res = array_slice(@array, 1, 3);
    assert(res.len() == 2, 'invalid length 2');
    assert(*res[0] == 2, 'invalid value 1');
    assert(*res[1] == 3, 'invalid value 2');
}

#[test]
#[available_gas(20000000000)]
fn test_u64_array_slice() {
    let mut array = ArrayTrait::<u64>::new();
    array.append(1);
    array.append(2);
    array.append(3);

    let res = array_slice(@array, 0, 2);
    assert(res.len() == 2, 'invalid length 1');
    assert(*res[0] == 1, 'invalid value 1');
    assert(*res[1] == 2, 'invalid value 2');

    let res = array_slice(@array, 1, 3);
    assert(res.len() == 2, 'invalid length 2');
    assert(*res[0] == 2, 'invalid value 1');
    assert(*res[1] == 3, 'invalid value 2');
}

#[test]
#[available_gas(20000000000)]
fn test_min() {
    let left: u8 = 1;
    let right: u8 = 2;
    assert(uint_min(left, right) == left, 'u8 min');

    let left: u16 = 1;
    let right: u16 = 0;
    assert(uint_min(left, right) == right, 'u16 min');

    let left: u32 = 1;
    let right: u32 = 1;
    assert(uint_min(left, right) == left, 'u32 min');

    let left: u64 = 1;
    let right: u64 = 2;
    assert(uint_min(left, right) == left, 'u64 min');

    let left: u128 = 1;
    let right: u128 = 2;
    assert(uint_min(left, right) == left, 'u128 min');

    let left: u256 = 1;
    let right: u256 = 2;
    assert(uint_min(left, right) == left, 'u256 min');
}

#[test]
fn test_u128_split_full() {
    let value = 0x01020304050607080102030405060708;
    let value_size = 16;

    // 1. left is 0x0
    let (left, rifht) = u128_split(value, value_size, 0);
    assert(left == 0, '1 invalid result');
    assert(rifht == value, '1 invalid result');

    // 2. left is 0x01020304
    let (left, rifht) = u128_split(value, value_size, 4);
    assert(left == 0x01020304, '2 invalid result');
    assert(rifht == 0x050607080102030405060708, '2 invalid result');

    // 3. left is 0x0102030405060708
    let (left, rifht) = u128_split(value, value_size, 8);
    assert(left == 0x0102030405060708, '3 invalid result');
    assert(rifht == 0x0102030405060708, '3 invalid result');

    // 4. left is 0x010203040506070801
    let (left, rifht) = u128_split(value, value_size, 9);
    assert(left == 0x010203040506070801, '4 invalid result');
    assert(rifht == 0x02030405060708, '4 invalid result');

    // 5. left is value
    let (left, rifht) = u128_split(value, value_size, value_size);
    assert(left == value, '5 invalid result');
    assert(rifht == 0, '5 invalid result');
}

#[test]
fn test_u128_split_common() {
    let value = 0x0102030405060708010203;
    let value_size = 11;

    // 1. left is 0x0
    let (left, rifht) = u128_split(value, value_size, 0);
    assert(left == 0, '1 invalid result');
    assert(rifht == value, '1 invalid result');

    // 2. left is 0x01020304
    let (left, rifht) = u128_split(value, value_size, 4);
    assert(left == 0x01020304, '2 invalid result');
    assert(rifht == 0x05060708010203, '2 invalid result');

    // 3. left is 0x0102030405060708
    let (left, rifht) = u128_split(value, value_size, 6);
    assert(left == 0x010203040506, '3 invalid result');
    assert(rifht == 0x0708010203, '3 invalid result');

    // 5. left is value
    let (left, rifht) = u128_split(value, value_size, value_size);
    assert(left == value, '4 invalid result');
    assert(rifht == 0, '4 invalid result');
}

#[test]
fn test_read_sub_u128_full() {
    let value = 0x01020304050607080102030405060708;
    let value_size = 16;

    // 1. offset=0, size=4
    let sub = read_sub_u128(value, value_size, 0, 4);
    assert(sub == 0x01020304, '1 invalid result');

    // 2. offset=0, size=value_size
    let sub = read_sub_u128(value, value_size, 0, value_size);
    assert(sub == value, '2 invalid result');

    // 3. offset=1, size=value_size-1
    let sub = read_sub_u128(value, value_size, 1, value_size - 1);
    assert(sub == 0x020304050607080102030405060708, '3 invalid result');

    // 4. offset=3, size=11
    let sub = read_sub_u128(value, value_size, 3, 11);
    assert(sub == 0x405060708010203040506, '4 invalid result');
}

#[test]
fn test_read_sub_u128_common() {
    let value = 0x010203040506070801;
    let value_size = 9;

    // 1. offset=0, size=4
    let sub = read_sub_u128(value, value_size, 0, 4);
    assert(sub == 0x01020304, '1 invalid result');

    // 2. offset=0, size=value_size
    let sub = read_sub_u128(value, value_size, 0, value_size);
    assert(sub == value, '2 invalid result');

    // 3. offset=1, size=value_size-1
    let sub = read_sub_u128(value, value_size, 1, value_size - 1);
    assert(sub == 0x0203040506070801, '3 invalid result');

    // 4. offset=3, size=11
    let sub = read_sub_u128(value, value_size, 3, 4);
    assert(sub == 0x4050607, '4 invalid result');
}

#[test]
fn test_u128_join() {
    let left = 0x0102;
    let right = 0x0304;
    assert(u128_join(left, right, 2) == 0x01020304, 'invalid result');
}
