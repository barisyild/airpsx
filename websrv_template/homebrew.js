/* Copyright (C) 2025 John Törnblom

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 3, or (at your option) any
later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING. If not, see
<http://www.gnu.org/licenses/>.  */


async function main() {
    const PAYLOAD_NAME = 'airpsx.elf';
    const PAYLOAD_PATH = window.workingDir + '/' + PAYLOAD_NAME;

    return {
        mainText: "AirPSX",
        secondaryText: 'Remote control software for PlayStation 5.',
        onclick: async () => {
            return {
                path: PAYLOAD_PATH,
                daemon: true
            };
        }
    };
}
