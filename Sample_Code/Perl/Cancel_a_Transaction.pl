##
# BluePay Perl Sample code.
#
# This code sample runs a $3.00 Credit Card Sale transaction
# against a customer using test payment information.
# If approved, a 2nd transaction is run to cancel this transaction.
# If using TEST mode, odd dollar amounts will return
# an approval and even dollar amounts will return a decline.
##

use BluePay::BluePayPayment_BP10Emu;
use strict;

my $ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
my $SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
my $MODE = "TEST";

my $payment = BluePay::BluePayPayment_BP10Emu->new();

# Merchant values
$payment->{MERCHANT} = $ACCOUNT_ID;
$payment->{SECRET_KEY} = $SECRET_KEY;
$payment->{MODE} = $MODE;

# Customer values
$payment->{NAME1} = 'Bob';
$payment->{NAME2} = 'Tester';
$payment->{ADDR1} = '123 Test St.';
$payment->{ADDR2} = 'Apt #500';
$payment->{CITY} = 'Testville';
$payment->{STATE} = 'IL';
$payment->{ZIPCODE} = '54321';
$payment->{COUNTRY} = 'USA';

# Payment values
$payment->{TRANSACTION_TYPE} = 'SALE';
$payment->{PAYMENT_TYPE} = 'CREDIT';
$payment->{AMOUNT} = '3.00';
$payment->{CC_NUM} = '4111111111111111';
$payment->{CC_EXPIRES} = '0815';
        
$payment->Post();

# If transaction was approved..
if($payment->{Result} == 'APPROVED') {

my $payment_void = BluePay::BluePayPayment_BP10Emu->new();

$payment_void->{MERCHANT} = $ACCOUNT_ID;
        $payment_void->{SECRET_KEY} = $SECRET_KEY;
$payment_void->{MODE} = $MODE;

# Attempts to void transaction above
        $payment_void->{TRANS_TYPE} = 'VOID';
$payment_void->{MASTER_ID} = $payment->{TRANS_ID};

        $payment_void->Post();

print "TRANSACTION ID: " . $payment->{RRNO} . "\n";
print "STATUS: " . $payment->{Result} . "\n";
print "TRANSACTION MESSAGE: " . $payment->{MESSAGE} . "\n";
print "AVS RESULT: " .$payment->{AVS} . "\n";
print "CVV2 RESULT: " . $payment->{CVV2} . "\n";
print "MASKED PAYMENT ACCOUNT: " . $payment->{PAYMENT_ACCOUNT} . "\n";
print "CARD TYPE: " . $payment->{CARD_TYPE} . "\n";
print "AUTH CODE: " . $payment->{AUTH_CODE} . "\n";
} else {
print $payment->{MESSAGE};
}