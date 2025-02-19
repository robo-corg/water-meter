use esp_idf_hal::delay::FreeRtos;
use esp_idf_hal::gpio::{PinDriver, Pull};
use esp_idf_hal::ledc::*;
use esp_idf_hal::peripherals::Peripherals;
use esp_idf_hal::prelude::*;
// use esp_idf_hal::rmt::config::TransmitConfig;
// use esp_idf_hal::rmt::*;

fn set_color(led: &mut [LedcDriver; 3], color: &[u8; 3]) -> anyhow::Result<()> {
    let max_duty = led[0].get_max_duty();

    for (channel, color_c) in led.iter_mut().zip(color) {
        let color_c_inv = u8::MAX - color_c;
        let duty = max_duty * color_c_inv as u32 / u8::MAX as u32;
        channel.set_duty(duty)?;
    }

    Ok(())
}

fn main() -> anyhow::Result<()> {
    // It is necessary to call this function once. Otherwise some patches to the runtime
    // implemented by esp-idf-sys might not link properly. See https://github.com/esp-rs/esp-idf-template/issues/71
    esp_idf_svc::sys::link_patches();

    // Bind the log crate to the ESP Logging facilities
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    let peripherals = Peripherals::take()?;

    let mut water_sensor = PinDriver::input(peripherals.pins.gpio0)?;

    water_sensor.set_pull(Pull::Up)?;

    let mut channel: LedcDriver = LedcDriver::new(
        peripherals.ledc.channel0,
        LedcTimerDriver::new(
            peripherals.ledc.timer0,
            &config::TimerConfig::new().frequency(25.kHz().into()),
        )?,
        peripherals.pins.gpio15,
    )?;

    let r_channel = LedcDriver::new(
        peripherals.ledc.channel1,
        LedcTimerDriver::new(
            peripherals.ledc.timer1,
            &config::TimerConfig::new().frequency(25.kHz().into()),
        )?,
        peripherals.pins.gpio1,
    )?;
    let g_channel = LedcDriver::new(
        peripherals.ledc.channel2,
        LedcTimerDriver::new(
            peripherals.ledc.timer2,
            &config::TimerConfig::new().frequency(25.kHz().into()),
        )?,
        peripherals.pins.gpio2,
    )?;
    let b_channel = LedcDriver::new(
        peripherals.ledc.channel3,
        LedcTimerDriver::new(
            peripherals.ledc.timer3,
            &config::TimerConfig::new().frequency(25.kHz().into()),
        )?,
        peripherals.pins.gpio21,
    )?;

    let mut led = [r_channel, g_channel, b_channel];

    let max_duty = channel.get_max_duty();

    set_color(&mut led, &[255, 255, 0])?;

    log::info!("Starting duty-cycle loop");

    for numerator in [0, 1, 2, 3, 4, 5].iter().cycle() {
        if water_sensor.is_low() {
            println!("Water detected");
            channel.set_duty(max_duty)?;
            set_color(&mut led, &[0, 0, 128])?;
            continue;
        } else {
            let amount = 255 * numerator / 5;
            set_color(&mut led, &[amount as u8, 0, 0])?;
        }

        channel.set_duty(max_duty * numerator / 5)?;

        FreeRtos::delay_ms(100);
    }

    loop {
        FreeRtos::delay_ms(1000);
    }
}
