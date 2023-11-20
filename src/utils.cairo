use traits::{Into, TryInto, PartialOrd, DivRem};
use array::{ArrayTrait, SpanTrait};
use option::OptionTrait;
use zklink_starknet_utils::math::{u128_fast_shift, u128_bytes_len};

/// Split a u128 into two parts, [0, left_size-1] and [left_size, end]
/// Parameters:
///  - value: data of u128
///  - value_size: the size of `value` in bytes
///  - left_size: the size of left part in bytes
/// Returns:
///  - letf: [0, left_size-1] of the origin u128
///  - right: [left_size, end] of the origin u128 which size is (value_size - left_size)
/// Examples:
/// u128_split(0x01020304, 4, 0) -> (0, 0x01020304)
/// u128_split(0x01020304, 4, 1) -> (0x01, 0x020304)
/// u128_split(0x0001020304, 5, 1) -> (0x00, 0x01020304)
fn u128_split(value: u128, value_size: usize, left_size: usize) -> (u128, u128) {
    assert(value_size <= 16, 'value_size can not be gt 16');
    assert(left_size <= value_size, 'size can not be gt value_size');

    if left_size == 0 {
        return (0_u128, value);
    } else {
        let (left, right) = DivRem::div_rem(
            value, u128_fast_shift(value_size - left_size).try_into().unwrap()
        );
        return (left, right);
    }
}

/// Read sub value from u128 just like substr in other language
/// Parameters:
///  - value: data of u128
///  - value_size: the size of data in bytes
///  - offset: the offset of sub value
///  - size: the size of sub value in bytes
/// Returns:
///  - sub_value: the sub value of origin u128
/// Examples:
/// read_sub_u128(0x000001020304, 6, 1, 3) -> 0x000102
fn read_sub_u128(value: u128, value_size: usize, offset: usize, size: usize) -> u128 {
    assert(offset + size <= value_size, 'too long');

    if (value_size == 0) || (size == 0) {
        return 0;
    }

    if size == value_size {
        return value;
    }

    let (_, right) = u128_split(value, value_size, offset);
    let (sub_value, _) = u128_split(right, value_size - offset, size);
    sub_value
}

/// Join two u128 into one
/// Parameters:
///  - left: the left part of u128
///  - right: the right part of u128
///  - right_size: the size of right part in bytes
/// Returns:
///  - value: the joined u128
/// Examples: 
/// u128_join(0x010203, 0xaabb, 2) -> 0x010203aabb
/// u128_join(0x010203, 0, 2) -> 0x0102030000
fn u128_join(left: u128, right: u128, right_size: usize) -> u128 {
    let left_size = u128_bytes_len(left);
    assert(left_size + right_size <= 16, 'left shift overflow');
    let shit = u128_fast_shift(right_size);
    left * shit + right
}

/// return the minimal value
/// support u8, u16, u32, u64, u128, u256
fn uint_min<T, impl TDrop: Drop<T>, impl TPartialOrd: PartialOrd<T>, impl TCopy: Copy<T>>(
    l: T, r: T
) -> T {
    if l <= r {
        return l;
    } else {
        return r;
    }
}

/// Returns the slice of an array.
/// * `arr` - The array to slice.
/// * `begin` - The index to start the slice at.
/// * `end` - The index to end the slice at (not included).
/// # Returns
/// * `Array<T>` - The slice of the array.
fn array_slice<T, impl TDrop: Drop<T>, impl TCopy: Copy<T>>(
    src: @Array<T>, mut begin: usize, end: usize
) -> Array<T> {
    let mut slice = ArrayTrait::new();
    let len = begin + end;
    loop {
        if begin >= len {
            break ();
        }
        if begin >= src.len() {
            break ();
        }

        slice.append(*src[begin]);
        begin += 1;
    };
    slice
}
