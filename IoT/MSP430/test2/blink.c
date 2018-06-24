#include <msp430.h>
#include <string.h>
#include <stdlib.h>

char cmd[64], sz = 0;

void blink(int n) {
    int i;
    P1OUT &= ~BIT0;
    while(n--) {
        P1OUT ^= BIT0;
        for(i = 0; i < 30000; ++i);
        P1OUT ^= BIT0;
        for(i = 0; i < 30000; ++i);
    }
}

void putc(char c) {
    while(!(IFG2 & UCA0TXIFG));
    UCA0TXBUF = c;
}

void putstr(const char *p) {
    while(*p) {
        putc(*p++);
    }
    putc('\n');
}

void parse() {
    char tmp[16];
    int x;
    if(cmd[0] == 'b') {
        strcpy(tmp, cmd + 2);
        x = atoi(tmp);
        blink(x);
    } else if(cmd[0] == 'e') {
        putstr(cmd + 2);
    }
}

int main(void)
{
    WDTCTL = WDTPW + WDTHOLD;

    DCOCTL = 0;
    BCSCTL1 = CALBC1_1MHZ;
    DCOCTL = CALDCO_1MHZ;

    P1DIR |= BIT0;
    P1OUT &= ~BIT0;

    P1SEL = BIT1 + BIT2;
    P1SEL2 = BIT1 + BIT2;

    UCA0CTL1 |= UCSSEL_2;                     // SMCLK
    UCA0BR0 = 104;                            // 1MHz 9600
    UCA0BR1 = 0;                              // 1MHz 9600
    UCA0MCTL = UCBRS_1;                        // Modulation UCBRSx = 1
    UCA0CTL1 &= ~UCSWRST;

    IE2 |= UCA0RXIE;                          // Enable USCI_A0 RX interrupt

    blink(3);
    __bis_SR_register(LPM0_bits + GIE);       // Enter LPM0, interrupts enabled
}

#pragma vector=USCIAB0RX_VECTOR
__interrupt void USCI0RX_ISR(void)
{
    char c = UCA0RXBUF;
    if(c == '\n' || c == '\r') {
        cmd[sz] = 0;
        parse();
        cmd[0] = 0;
        sz = 0;
        return;
    }
    cmd[sz++] = c;
}
