use esp_idf_hal::delay::FreeRtos;
use esp_idf_hal::gpio::{PinDriver, Pull};
use esp_idf_hal::ledc::*;
use esp_idf_hal::peripherals::Peripherals;
use esp_idf_hal::prelude::*;
// use esp_idf_hal::rmt::config::TransmitConfig;
// use esp_idf_hal::rmt::*;

fn main() -> anyhow::Result<()> {
    // It is necessary to call this function once. Otherwise some patches to the runtime
    // implemented by esp-idf-sys might not link properly. See https://github.com/esp-rs/esp-idf-template/issues/71
    esp_idf_svc::sys::link_patches();

    // Bind the log crate to the ESP Logging facilities
    esp_idf_svc::log::EspLogger::initialize_default();

    log::info!("Hello, world!");

    let peripherals = Peripherals::take()?;

    let mut water_sensor = PinDriver::input(peripherals.pins.gpio0)?;

    //water_sensor.set_pull(Pull::Down)?;


    let mut channel = LedcDriver::new(
        peripherals.ledc.channel0,
        LedcTimerDriver::new(
            peripherals.ledc.timer0,
            &config::TimerConfig::new().frequency(25.kHz().into()),
        )?,
        peripherals.pins.gpio15,
    )?;

    log::info!("Starting duty-cycle loop");

    let max_duty = channel.get_max_duty();
    for numerator in [0, 1, 2, 3, 4, 5].iter().cycle() {
        if water_sensor.is_high() {
            println!("Water detected");
        }

        channel.set_duty(max_duty * numerator / 5)?;
        FreeRtos::delay_ms(100);
    }

    loop {
        FreeRtos::delay_ms(1000);
    }
}
