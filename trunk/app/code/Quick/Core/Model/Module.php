<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      Quick Core Team <core@Quickcommerce.com>
 */
class Quick_Core_Model_Module extends Quick_Db_Table
{    
    protected $_name = 'core_module';
    
    private $_processed_modules = null;
    
    /**
     * Retrieve array of installed modules
     * 
     * @return array
     */
    public function getList($where = null)
    {
        $query = "SELECT cm.code, cm.*
            FROM {$this->_name} AS cm";
        
        if (null !== $where) {
            $query .= " WHERE {$where}";
        }
        
        return $this->getAdapter()->fetchAssoc($query);
    }
    
    /**
     * Retrieve array of all modules from filesystem
     * 
     * @return array
     */
    public function getModules()
    {
        $codePath = Quick::config()->system->path . '/app/code';
        try {
            $code_dir = new DirectoryIterator($codePath);
        } catch (Exception $e) {
            throw new Quick_Exception(
                Quick::translate('core')->__(
                    "Directory %s not readable", $codePath
                )
            );
        }
        
        $modules = array();
        foreach ($code_dir as $category) {
            $category_path = $category->getPathname();
            $category = $category->getFilename();
            if ($category[0] == '.') {
                continue;
            }
            try {
                $categoryDir = new DirectoryIterator($category_path);
            } catch (Exception $e) {
                continue;
            }
            foreach ($categoryDir as $module) {
                $modulePath = $module->getPathname();
                $module = $module->getFilename();
                $configFile = $modulePath . '/etc/config.php';
                if ($module[0] == '.' || !is_file($configFile)) {
                    continue;
                }
                include_once($configFile);
                if (!isset($config)) {
                    continue;
                }
                $config[key($config)]['has_install'] = $this->hasInstall(
                    $category . '_' . $module
                );
                $config[key($config)]['has_uninstall'] = false;
                $config[key($config)]['has_upgrade'] = false;
                $config[key($config)]['upgrade_tooltip'] = '';
                $config[key($config)]['install_tooltip'] =
                    $this->getConfigVersion($category . '_' . $module);
                
                if ($this->isInstalled($category . '_' . $module)) {
                    $config[key($config)]['has_uninstall'] =
                        $this->hasUninstall($category . '_' . $module);
                    $hasUpgrade = $this->hasUpgrade($category . '_' . $module);
                    $config[key($config)]['has_upgrade'] = $hasUpgrade;
                    if ($hasUpgrade) {
                        $config[key($config)]['upgrade_tooltip'] =
                            $this->getConfigVersion($category . '_' . $module);
                    }
                }
                $modules += $config;
            }
        }
        return $modules;
    }
    
    /**
     * Checks, is module is installed.
     * Made a query to DB everytime when calling.
     * Used during module installation
     * 
     * @param string $module
     * @return bool
     */
    public function isInstalled($module)
    {
        return (bool)$this->getIdByCode($module);
    }
    
    /**
     * Check, is module has install file
     * 
     * @param string $module
     * @return bool
     */
    public function hasInstall($module)
    {
        list($category, $module) = explode('_', $module, 2);
        return is_file(
            Quick::config()->system->path . 
            '/app/code/' . $category . '/' . $module . '/sql/install.php'
        );
    }
    
    /**
     * Check, is module has uninstall file
     * 
     * @param string $module
     * @return bool
     */
    public function hasUninstall($module)
    {
        list($category, $module) = explode('_', $module, 2);
        return is_file(
            Quick::config()->system->path . 
            '/app/code/' . $category . '/' . $module . '/sql/uninstall.php'
        );
    }
    
    /**
     * Check, is module has upgrade from current version
     * 
     * @param string $module
     * @return bool
     */
    public function hasUpgrade($module)
    {
        $currentVersion = $this->getVersionByCode($module);
        $updateTo = $this->getConfigVersion($module);
        
        if (version_compare($updateTo, $currentVersion) === 0) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Retrieve version from config file
     * 
     * @param string $module
     * @return string
     */
    public function getConfigVersion($module)
    {
        $config = current($this->getConfig($module));
        return $config['version'];
    }
    
    public function getCurrentVersion($module)
    {
        return $this->getVersionByCode($module);
    }
    
    /**
     * Retrieve the array of available upgrades
     * 
     * @param string $module
     * @return array
     */
    public function getAvailableUpgrades($module)
    {
        list($category, $module) = explode('_', $module, 2);
        $sqlPath = Quick::config()->system->path . '/app/code/'
            . $category . '/' . $module . '/sql/';
        
        try {
            $sqlDir = new DirectoryIterator($sqlPath);
        } catch (Exception $e) {
            return array();
        }
        
        $upgrades = array();
        foreach ($sqlDir as $sqlFile) {
            $sqlFile = $sqlFile->getFilename();
            if (false === strstr($sqlFile, 'upgrade')) {
                continue;
            }
            $upgrades[] = $sqlFile;
        }
        return $upgrades;
    }
    
    /**
     * Retrieve the config of module
     * 
     * @param string $module
     * @return mixed(array|boolean)
     */
    public function getConfig($module = null)
    {
        if (null === $module) {
            if (!$result = Quick::cache()->load('Quick_modules_config')) {
                $modules = Quick::getModules();
                $result = array();
                foreach ($modules as $moduleCode => $path) {
                    if (file_exists($path . '/etc/config.php') 
                        && is_readable($path . '/etc/config.php')) {
                        
                        include_once($path . '/etc/config.php');
                        if (!isset($config)) {
                            continue;
                        }
                        $result += $config;
                    }
                }
                Quick::cache()->save(
                    $result, 'Quick_modules_config', array('modules')
                );
            }
            $config = $result;
        } else {
            list($category, $module) = explode('_', $module, 2);
            $configFile = Quick::config()->system->path . '/app/code/'
                . $category . '/' . $module . '/etc/config.php';
    
            if (!is_file($configFile)) {
                return false;
            }
                
            include($configFile);
            
            if (!isset($config)) {
                return false;
            }
        }
        return $config;
    }
    
    /**
     * Return path to installation file
     * 
     * @param string $module
     * @return string
     */
    public function getInstall($module)
    {
        list($category, $module) = explode('_', $module, 2);
        return Quick::config()->system->path . 
            '/app/code/' . $category . '/' . $module . '/sql/install.php';
    }
    
    /**
     * Return path to uninstall file
     * 
     * @param string $module
     * @return string
     */
    public function getUninstall($module)
    {
        list($category, $module) = explode('_', $module, 2);
        return Quick::config()->system->path . 
            '/app/code/' . $category . '/' . $module . '/sql/uninstall.php';
    }
    
    /**
     * Checks is the module can be installed
     * 
     * @param string $module
     * @return bool
     */
    public function canInstall($module, $silent = false)
    {
        if ($this->isInstalled($module)) {
            if (!$silent) {
                Quick::message()->addNotice(
                    Quick::translate('core')->__(
                        "Module '%s' is installed already", $module
                ));
            }
            return false;
        }
        
        if (!$this->hasInstall($module)) {
            if (!$silent) {
                Quick::message()->addError(
                    Quick::translate('core')->__(
                        "Installation file not found for '%s'", $module
                ));
            }
            return false;
        }
        
        return true;
    }
    
    /**
     * Run the installation file of module
     * 
     * @param string $module
     * @return bool
     */
    public function install($module, $silent = false)
    {
        if (null === $this->_processed_modules) {
            $this->_processed_modules = array();
        } elseif (in_array($module, $this->_processed_modules)) {
            return false;
        }
        $this->_processed_modules[$module] = $module;
        
        if (!$this->canInstall($module, $silent)) {
            return false;
        }
        
        if (!$this->installDependencies($module)) {
            return false;
        }
        
        include($this->getInstall($module));
        if (!$silent) {
            Quick::message()->addSuccess(
                Quick::translate('core')->__(
                    "Module '%s' was successfully installed", $module
            ));
        }
        return true;
    }
    
    /**
     * Install or update modules wich affect on requested module
     * 
     * @param string $module
     * @return bool
     * @throws Quick_Exception
     */
    public function installDependencies($module)
    {
        $config = current($this->getConfig($module));
        
        if (!isset($config['depends']) || !count($config['depends'])) {
            return true;
        }
        
        foreach ($config['depends'] as $key => $values) {
            if (is_array($values)) {
                $dependency = $key;
                $this->install($dependency, true);
                if (!$this->isInstalled($dependency)) {
                    Quick::message()->addError(
                        Quick::translate('core')->__(
                            "Module '%s' is required by '%s', but can't be installed",
                            $dependency, $module
                    ));
                    return false;
                    throw new Quick_Exception(
                        Quick::translate('core')->__(
                            "Module '%s' is required by '%s', but can't be installed",
                            $dependency, $module
                    ));
                }
                foreach ($values['version'] as $operator => $version) {
                    if (!version_compare($this->getCurrentVersion($dependency), $version, $operator)) {
                        $this->applyUpgrades($dependency, $this->getUpgradeChain(
                                $dependency, 
                                $this->getCurrentVersion($dependency), 
                                $version
                            )
                        );
                    }
                    if (!version_compare($this->getCurrentVersion($dependency), $version, $operator)) {
                        Quick::message()->addError(
                            Quick::translate('core')->__(
                                "Module '%s', (version %s %s) is required by '%s', but can't be upgraded",
                                $dependency, $operator, $version, $module
                        ));
                        return false;
                        throw new Quick_Exception(
                            Quick::translate('core')->__(
                                "Module '%s', (version %s %s) is required by '%s', but can't be upgraded",
                                $dependency, $operator, $version, $module
                        ));
                    }
                }
            } else {
                $dependency = $values;
                $this->install($dependency, true);
                if (!$this->isInstalled($dependency)) {
                    Quick::message()->addError(
                        Quick::translate('core')->__(
                            "Module '%s' is required by '%s', but can't be installed",
                            $dependency, $module
                    ));
                    return false;
                    throw new Quick_Exception(
                        Quick::translate('core')->__(
                            "Module '%s' is required by '%s', but can't be installed",
                            $dependency, $module
                    ));
                }
            }
        }
        return true;
    }
    
    /**
     * Run the uninstall file of module
     * 
     * @param string $module
     * @return bool
     */
    public function uninstall($module)
    {
        if (!$this->isInstalled($module)) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'Module is not installed yet'
            ));
            return false;
        }
        
        if (!$this->hasUninstall($module)) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'Uninstall file not found'
            ));
            return false;
        }
        
        include($this->getUninstall($module));
        Quick::message()->addSuccess(
            Quick::translate('core')->__(
                'Module was successfully uninstalled'
        ));
        return true;
    }
    
    /**
     * Upgrade module version
     * 
     * @param string $module
     * @return bool
     */
    public function upgrade($module)
    {
        $currentVersion = $this->getVersionByCode($module);
        
        if (false === $currentVersion) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'Module is not installed yet'
            ));
            return false;
        }
        
        if ((!$config = $this->getConfig($module)) 
            || !isset($config[key($config)]['version'])) {
            
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'Config file is corrupted'
            ));
            return false;
        }
        
        $updateTo = $config[key($config)]['version'];
        
        if (version_compare($updateTo, $currentVersion) === 0) {
            Quick::message()->addNotice(
                Quick::translate('core')->__(
                    'Latest version of module is already installed'
            ));
            return true;
        }
        
        $upgradeFiles = $this->getUpgradeChain(
            $module, $currentVersion, $updateTo
        );
        if (!count($upgradeFiles)) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    "Can't upgrade module to %s. Upgrade file not found",
                    $updateTo
            ));
            return false;
        }
        
        return $this->applyUpgrades($module, $upgradeFiles);
    }
    
    /**
     * Retrieve the set of upgrade files.
     * Steps to upgrade module from one version to another
     * 
     * @param string $module
     * @param string $from
     * @param string $to
     * @return array
     */
    public function getUpgradeChain($module, $from, $to)
    {
        $upgrade_files = $this->getAvailableUpgrades($module);
        
        $upgrades = array();
        foreach ($upgrade_files as $file_name) {
            $upgrade_parts = explode('-', substr($file_name, 8, -4)); // 'upgrade-' 8 symbols, '.php' 4 symbols
            $upgrades['from'][$file_name] = $upgrade_parts[0];
            $upgrades['to'][$file_name] = $upgrade_parts[1];
        }
        
        if (!count($upgrades)) {
            return array();
        }
        
        $completed = false;
        $upgrade_chain = array();
        $i = 0;
        do {
            $upgrade_chain[$i] = array_search($from, $upgrades['from']);
            if (false === $upgrade_chain[$i]) {
                $upgrade_chain = array();
                $completed = true;
                break;
            }
            $from = $upgrades['to'][$upgrade_chain[$i]];
            if ($upgrade_chain[$i] == array_search($to, $upgrades['to'])) {
                $completed = true;
            }
            $i++;
        } while (!$completed);
        
        return $upgrade_chain;
    }
    
    /**
     * Apply set of upgrades
     * 
     * @param string $module
     * @param array $upgrade_files
     * @return bool
     */
    public function applyUpgrades($module, $upgrade_files)
    {
        list($category, $module) = explode('_', $module, 2);
        
        if (!is_array($upgrade_files)) {
            $upgrade_files = array($upgrade_files);
        }
        
        foreach ($upgrade_files as $file) {
            include(Quick::config()->system->path . 
            '/app/code/' . $category . '/' . $module . '/sql/' . $file);
        }
        
        return true;
    }
    
}