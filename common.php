<?php 
# run a system command and capture STDOUT + STDERR
function run_cmd ($cmd, $ignore_errors = false) {
        $proc = proc_open($cmd, array(1 => array('pipe', 'w'), 2 => array('pipe', 'w')), $pipes);
        $stdout = stream_get_contents($pipes[1]);
        fclose($pipes[1]);
        $stderr = stream_get_contents($pipes[2]);
        fclose($pipes[2]);
        if ($stderr)
                $stdout .= '<span style="color: red;">' . $stderr . '</span>';
        if (proc_close($proc) != 0) {
                if (! $ignore_errors)
                        die_with_color("Error while running '$cmd':\n$stderr");
        }
        return rtrim($stdout);
}
# fatal condition - die with colourful message
function die_with_color ($msg) {
        echo('<span style="color: red;">' . $msg . '</span><br />');
        exit;
}

function run_cmd_output ($cmd, $ignore_errors = false) {
	while (@ ob_end_flush()); // end all output buffers if any

	$proc = popen($cmd, 'w');
	echo '<pre>';
	while (!feof($proc))
	{
	    echo fread($proc, 100000);
	    @ flush();
	}
	echo '</pre>';
	pclose($proc);
}

?>